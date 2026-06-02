ruby
# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Ai::DuoWorkflows::TriggerService, feature_category: :duo_workflow do
  include StubRequests

  let_it_be(:user) { create(:user) }
  let_it_be(:target_user) { create(:user) }
  let_it_be(:project) { create(:project, :repository) }

  let(:workflow_id) { SecureRandom.uuid }
  let(:params) do
    {
      workflow_id: workflow_id,
      project_id: project.id,
      user_id: target_user.id
    }
  end

  subject(:service) { described_class.new(user: user, params: params) }

  describe '#execute' do
    context 'when user identity bypass is attempted' do
      it 'prevents running workflow under another user identity' do
        expect do
          service.execute
        end.to raise_error(::Gitlab::Access::AccessDeniedError)
      end

      it 'does not create workflow for target user' do
        expect do
          service.execute
        rescue ::Gitlab::Access::AccessDeniedError
          # Expected
        end.not_to change { ::Ai::DuoWorkflow::Workflow.count }
      end

      it 'logs the security event' do
        expect(::Gitlab::AppLogger).to receive(:warn).with(
          hash_including(
            message: 'Duo Workflow user identity bypass attempt',
            user_id: user.id,
            attempted_user_id: target_user.id,
            workflow_id: workflow_id
          )
        )

        expect do
          service.execute
        end.to raise_error(::Gitlab::Access::AccessDeniedError)
      end

      context 'when user has admin permissions' do
        let_it_be(:user) { create(:user, :admin) }

        it 'still prevents running workflow under another user identity' do
          expect do
            service.execute
          end.to raise_error(::Gitlab::Access::AccessDeniedError)
        end
      end

      context 'when user is project maintainer' do
        before do
          project.add_maintainer(user)
        end

        it 'still prevents running workflow under another user identity' do
          expect do
            service.execute
          end.to raise_error(::Gitlab::Access::AccessDeniedError)
        end
      end
    end

    context 'when user runs workflow under their own identity' do
      let(:params) do
        {
          workflow_id: workflow_id,
          project_id: project.id,
          user_id: user.id
        }
      end

      before do
        project.add_developer(user)
      end

      it 'allows running workflow under own identity' do
        expect do
          service.execute
        end.not_to raise_error
      end

      it 'creates workflow for the correct user' do
        expect do
          service.execute
        end.to change { ::Ai::DuoWorkflow::Workflow.where(user: user).count }.by(1)
      end
    end

    context 'when user_id is not provided' do
      let(:params) do
        {
          workflow_id: workflow_id,
          project_id: project.id
        }
      end

      before do
        project.add_developer(user)
      end

      it 'defaults to current user' do
        expect do
          service.execute
        end.not_to raise_error
      end

      it 'creates workflow for current user' do
        expect do
          service.execute
        end.to change { ::Ai::DuoWorkflow::Workflow.where(user: user).count }.by(1)
      end
    end

    context 'when user_id is nil' do
      let(:params) do
        {
          workflow_id: workflow_id,
          project_id: project.id,
          user_id: nil
        }
      end

      before do
        project.add_developer(user)
      end

      it 'defaults to current user' do
        expect do
          service.execute
        end.not_to raise_error
      end

      it 'creates workflow for current user' do
        expect do
          service.execute
        end.to change { ::Ai::DuoWorkflow::Workflow.where(user: user).count }.by(1)
      end
    end

    context 'when user does not have access to project' do
      let(:params) do
        {
          workflow_id: workflow_id,
          project_id: project.id,
          user_id: user.id
        }
      end

      it 'raises access denied error' do
        expect do
          service.execute
        end.to raise_error(::Gitlab::Access::AccessDeniedError)
      end
    end

    context 'when project does not exist' do
      let(:params) do
        {
          workflow_id: workflow_id,
          project_id: non_existent_record_id,
          user_id: user.id
        }
      end

      it 'raises not found error' do
        expect do
          service.execute
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when workflow_id is already taken' do
      let!(:existing_workflow) do
        create(:duo_workflow_workflow,
          workflow_id: workflow_id,
          user: user,
          project: project
        )
      end

      let(:params) do
        {
          workflow_id: workflow_id,
          project_id: project.id,
          user_id: user.id
        }
      end

      before do
        project.add_developer(user)
      end

      it 'raises duplicate workflow error' do
        expect do
          service.execute
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when user is blocked' do
      let_it_be(:user) { create(:user, :blocked) }

      let(:params) do
        {
          workflow_id: workflow_id,
          project_id: project.id,
          user_id: user.id
        }
      end

      it 'raises access denied error' do
        expect do
          service.execute
        end.to raise_error(::Gitlab::Access::AccessDeniedError)
      end
    end

    context 'when user is a bot' do
      let_it_be(:user) { create(:user, :bot) }

      let(:params) do
        {
          workflow_id: workflow_id,
          project_id: project.id,
          user_id: user.id
        }
      end

      before do
        project.add_developer(user)
      end

      it 'allows running workflow for bot user' do
        expect do
          service.execute
        end.not_to raise_error
      end

      it 'creates workflow for bot user' do
        expect do
          service.execute
        end.to change { ::Ai::DuoWorkflow::Workflow.where(user: user).count }.by(1)
      end
    end

    context 'when user is a service account' do
      let_it_be(:user) { create(:user, :service_account) }

      let(:params) do
        {
          workflow_id: workflow_id,
          project_id: project.id,
          user_id: user.id
        }
      end

      before do
        project.add_developer(user)
      end

      it 'allows running workflow for service account' do
        expect do
          service.execute
        end.not_to raise_error
      end

      it 'creates workflow for service account' do
        expect do
          service.execute
        end.to change { ::Ai::DuoWorkflow::Workflow.where(user: user).count }.by(1)
      end
    end

    context 'when multiple workflows are triggered simultaneously' do
      let(:params) do
        {
          workflow_id: SecureRandom.uuid,
          project_id: project.id,
          user_id: user.id
        }
      end

      before do
        project.add_developer(user)
      end

      it 'handles concurrent requests without identity confusion' do
        threads = []
        results = []

        5.times do |i|
          threads << Thread.new do
            service = described_class.new(
              user: user,
              params: params.merge(workflow_id: SecureRandom.uuid)
            )
            begin
              result = service.execute
              results << { success: true, workflow_id: result.workflow_id }
            rescue StandardError => e
              results << { success: false, error: e.message }
            end
          end
        end

        threads.each(&:join)

        expect(results.count { |r| r[:success] }).to eq(5)
        workflow_ids = results.select { |r| r[:success] }.map { |r| r[:workflow_id] }
        expect(workflow_ids.uniq.count).to eq(5)
      end
    end

    context 'when user_id is an empty string' do
      let(:params) do
        {
          workflow_id: workflow_id,
          project_id: project.id,
          user_id: ''
        }
      end

      before do
        project.add_developer(user)
      end

      it 'defaults to current user' do
        expect do
          service.execute
        end.not_to raise_error
      end

      it 'creates workflow for current user' do
        expect do
          service.execute
        end.to change { ::Ai::DuoWorkflow::Workflow.where(user: user).count }.by(1)
      end
    end

    context 'when user_id is a non-numeric string' do
      let(:params) do
        {
          workflow_id: workflow_id,
          project_id: project.id,
          user_id: 'invalid_user_id'
        }
      end

      it 'raises argument error' do
        expect do
          service.execute
        end.to raise_error(ArgumentError)
      end
    end

    context 'when project_id is invalid' do
      let(:params) do
        {
          workflow_id: workflow_id,
          project_id: -1,
          user_id: user.id
        }
      end

      it 'raises not found error' do
        expect do
          service.execute
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when workflow_id is nil' do
      let(:params) do
        {
          workflow_id: nil,
          project_id: project.id,
          user_id: user.id
        }
      end

      before do
        project.add_developer(user)
      end

      it 'raises validation error' do
        expect do
          service.execute
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when workflow_id is an empty string' do
      let(:params) do
        {
          workflow_id: '',
          project_id: project.id,
          user_id: user.id
        }
      end

      before do
        project.add_developer(user)
      end

      it 'raises validation error' do
        expect do
          service.execute
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when user is deleted' do
      let_it_be(:user) { create(:user, :deleted) }

      let(:params) do
        {
          workflow_id: workflow_id,
          project_id: project.id,
          user_id: user.id
        }
      end

      it 'raises access denied error' do
        expect do
          service.execute
        end.to raise_error(::Gitlab::Access::AccessDeniedError)
      end
    end

    context 'when project is archived' do
      let_it_be(:project) { create(:project, :repository, :archived) }

      let(:params) do
        {
          workflow_id: workflow_id,
          project_id: project.id,
          user_id: user.id
        }
      end

      before do
        project.add_developer(user)
      end

      it 'raises access denied error' do
        expect do
          service.execute
        end.to raise_error(::Gitlab::Access::AccessDeniedError)
      end
    end

    context 'when project is in read-only mode' do
      let_it_be(:project) { create(:project, :repository, :read_only) }

      let(:params) do
        {
          workflow_id: workflow_id,
          project_id: project.id,
          user_id: user.id
        }
      end

      before do
        project.add_developer(user)
      end

      it 'raises access denied error' do
        expect do
          service.execute
        end.to raise_error(::Gitlab::Access::AccessDeniedError)
        end
      end
    end

    context 'when user has expired access to project' do
      before do
        project.add_developer(user, expires_at: 1.day.ago)
      end

      let(:params) do
        {
          workflow_id: workflow_id,
          project_id: project.id,
          user_id: user.id
        }
      end

      it 'raises access denied error' do
        expect do
          service.execute
        end.to raise_error(::Gitlab::Access::AccessDeniedError)
      end
    end

    context 'when user is a project guest' do
      before do
        project.add_guest(user)
      end

      let(:params) do
        {
          workflow_id: workflow_id,
          project_id: project.id,
          user_id: user.id
        }
      end

      it 'raises access denied error' do
        expect do
          service.execute
        end.to raise_error(::Gitlab::Access::AccessDeniedError)
      end
    end

    context 'when user is a project reporter' do
      before do
        project.add_reporter(user)
      end

      let(:params) do
        {
          workflow_id: workflow_id,
          project_id: project.id,
          user_id: user.id
        }
      end

      it 'raises access denied error' do
        expect do
          service.execute
        end.to raise_error(::Gitlab::Access::AccessDeniedError)
      end
    end

    context 'when user is a project developer' do
      before do
        project.add_developer(user)
      end

      let(:params) do
        {
          workflow_id: workflow_id,
          project_id: project.id,
          user_id: user.id
        }
      end

      it 'allows running workflow' do
        expect do
          service.execute
        end.not_to raise_error
      end
    end

    context 'when user is a project maintainer' do
      before do
        project.add_maintainer(user)
      end

      let(:params) do
        {
          workflow_id: workflow_id,
          project_id: project.id,
          user_id: user.id
        }
      end

      it 'allows running workflow' do
        expect do
          service.execute
        end.not_to raise_error
      end
    end

    context 'when user is a project owner' do
      let_it_be(:user) { project.owner }

      let(:params) do
        {
          workflow_id: workflow_id,
          project_id: project.id,
          user_id: user.id
        }
      end

      it 'allows running workflow' do
        expect do
          service.execute
        end.not_to raise_error
      end
    end

    context 'when user has access through group membership' do
      let_it_be(:group) { create(:group) }
      let_it_be(:project) { create(:project, :repository, group: group) }

      before do
        group.add_developer(user)
      end

      let(:params) do
        {
          workflow_id: workflow_id,
          project_id: project.id,
          user_id: user.id
        }
      end

      it 'allows running workflow' do
        expect do
          service.execute
        end.not_to raise_error
      end
    end

    context 'when user has access through project share' do
      let_it_be(:shared_group) { create(:group) }

      before do
        shared_group.add_developer(user)
        project.project_group_links.create!(group: shared_group, group_access: Gitlab::Access::DEVELOPER)
      end

      let(:params) do
        {
          workflow_id: workflow_id,
          project_id: project.id,
          user_id: user.id
        }
      end

      it 'allows running workflow' do
        expect do
          service.execute
        end.not_to raise_error
      end
    end

    context 'when user is a project bot' do
      let_it_be(:user) { create(:user, :project_bot) }

      before do
        project.add_developer(user)
      end

      let(:params) do
        {
          workflow_id: workflow_id,
          project_id: project.id,
          user_id: user.id
        }
      end

      it 'allows running workflow for project bot' do
        expect do
          service.execute
        end.not_to raise_error
      end

      it 'creates workflow for project bot' do
        expect do
          service.execute
        end.to change { ::Ai::DuoWorkflow::Workflow.where(user: user).count }.by(1)
      end
    end

    context 'when user is a ghost user' do
      let_it_be(:user) { create(:user, :ghost) }

      let(:params) do
        {
          workflow_id: workflow_id,
          project_id: project.id,
          user_id: user.id
        }
      end

      it 'raises access denied error' do
        expect do
          service.execute
        end.to raise_error(::Gitlab::Access::AccessDeniedError)
      end
    end

    context 'when user is an internal user' do
      let_it_be(:user) { create(:user, :internal) }

      let(:params) do
        {
          workflow_id: workflow_id,
          project_id: project.id,
          user_id: user.id
        }
      end

      before do
        project.add_developer(user)
      end

      it 'allows running workflow for internal user' do
        expect do
          service.execute
        end.not_to raise_error
      end
    end

    context 'when user is an external user' do
      let_it_be(:user) { create(:user, :external) }

      let(:params) do
        {
          workflow_id: workflow_id,
          project_id: project.id,
          user_id: user.id
        }