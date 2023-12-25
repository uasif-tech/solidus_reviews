# frozen_string_literal: true

require 'spec_helper'

describe Spree::Admin::FeedbackReviewsController do
  stub_authorization!

  before do
    user = create(:admin_user)
    allow(controller).to receive(:spree_current_user).and_return(user)
  end

  describe '#index' do
    let!(:review) { create(:review) }
    let!(:other_review) { create(:review) }

    let!(:feedback_review_1) { create(:feedback_review, created_at: 10.days.ago, review: review) }
    let!(:feedback_review_2) { create(:feedback_review, created_at: 2.days.ago, review: review) }
    let!(:feedback_review_3) { create(:feedback_review, created_at: 5.days.ago, review: review) }

    let!(:other_feedback_review_1) { create(:feedback_review, created_at: 10.days.ago, review: other_review) }
    let!(:other_feedback_review_2) { create(:feedback_review, created_at: 2.days.ago, review: other_review) }

    it 'looks up feedback reviews for the specified review and renders the template' do
      get :index, params: { review_id: review.id }
      expect(response.status).to eq(200)
      expect(response).to render_template(:index)
      expect(assigns(:collection)).to eq([feedback_review_2, feedback_review_3, feedback_review_1])
    end
  end
end
