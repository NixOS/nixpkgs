ruby
# frozen_string_literal: true

module EE
  module Ai
    module DuoWorkflows
      class Workflow < ApplicationRecord
        include WorkflowStates
        include Redactable
        include EachBatch
        include FromUnion
        include Sortable
        include CreatedAtFilterable
        include UpdatedAtFilterable

        # ============================================================================
        # Constants
        # ============================================================================

        VALID_STATUSES = %w[active completed failed cancelled].freeze
        MAX_PARAMS_SIZE = 10_000
        WORKFLOW_CLASSES = %w[DuoChat DuoReview DuoCodeReview].freeze

        # ============================================================================
        # Associations
        # ============================================================================

        belongs_to :project
        belongs_to :user
        belongs_to :triggering_user, class_name: 'User', optional: true

        has_many :workflow_steps,
                 class_name: 'EE::Ai::DuoWorkflows::WorkflowStep',
                 foreign_key: :workflow_id,
                 inverse_of: :workflow,
                 dependent: :destroy

        has_many :workflow_events,
                 class_name: 'EE::Ai::DuoWorkflows::WorkflowEvent',
                 foreign_key: :workflow_id,
                 inverse_of: :workflow,
                 dependent: :destroy

        # ============================================================================
        # Validations
        # ============================================================================

        validates :project, presence: true
        validates :user, presence: true
        validates :workflow_class, presence: true,
                                   inclusion: { in: WORKFLOW_CLASSES, message: '%{value} is not a valid workflow class' }
        validates :status, presence: true,
                           inclusion: { in: VALID_STATUSES, message: '%{value} is not a valid status' }
        validates :params, json_schema: { filename: 'duo_workflows_workflow_params' }, allow_blank: true
        validates :params, length: { maximum: MAX_PARAMS_SIZE }, allow_blank: true

        validate :triggering_user_belongs_to_project, if: :triggering_user_id_changed?
        validate :user_belongs_to_project, if: :user_id_changed?
        validate :triggering_user_must_be_authorized, if: :triggering_user_id_changed?
        validate :user_identity_resolution, on: :create
        validate :triggering_user_identity_resolution, on: :create

        # ============================================================================
        # Scopes
        # ============================================================================

        scope :for_project, ->(project) { where(project_id: project) }
        scope :for_user, ->(user) { where(user_id: user) }
        scope :for_triggering_user, ->(user) { where(triggering_user_id: user) }
        scope :active, -> { where(status: :active) }
        scope :completed, -> { where(status: :completed) }
        scope :failed, -> { where(status: :failed) }
        scope :cancelled, -> { where(status: :cancelled) }

        # ============================================================================
        # Callbacks
        # ============================================================================

        before_validation :set_default_status, on: :create
        before_validation :set_triggering_user, on: :create
        after_commit :log_workflow_creation, on: :create

        # ============================================================================
        # Public Interface
        # ============================================================================

        # CVE-2026-4868: Override to enforce identity constraints during workflow triggering
        #
        # @param triggering_user [User] The user triggering the workflow
        # @return [Boolean] true if the workflow was successfully triggered
        # @raise [ArgumentError] if triggering_user is nil
        # @raise [SecurityError] if identity validation fails
        def trigger!(triggering_user: nil)
          raise ArgumentError, 'triggering_user is required' unless triggering_user.is_a?(User)

          validate_identity!(triggering_user)

          update!(
            triggering_user: triggering_user,
            triggered_at: Time.current
          )

          execute_workflow!
        rescue ActiveRecord::RecordInvalid => e
          log_error('Workflow trigger failed due to validation errors', e)
          false
        rescue SecurityError => e
          log_security_event('Identity validation failed during workflow trigger', e)
          raise
        end

        # ============================================================================
        # Private Methods
        # ============================================================================

        private

        # CVE-2026-4868: Validate user identity resolution
        #
        # Prevents an authenticated user from causing Duo AI workflows to run
        # under another user's identity by enforcing strict identity checks.
        #
        # @return [void]
        def user_identity_resolution
          return unless user && triggering_user

          return if user == triggering_user || allowed_identity_delegation?

          errors.add(:user, 'cannot be different from triggering user without proper authorization')
        end

        # CVE-2026-4868: Validate triggering user identity resolution
        #
        # Ensures that the triggering user has explicit permission to act on behalf
        # of another user.
        #
        # @return [void]
        def triggering_user_identity_resolution
          return unless triggering_user

          unless triggering_user.can?(:trigger_duo_workflow, project)
            errors.add(:triggering_user, 'does not have permission to trigger workflows')
            return
          end

          return unless user && user != triggering_user

          return if triggering_user.can?(:trigger_workflow_as_user, project)

          errors.add(:triggering_user, 'cannot trigger workflows on behalf of another user')
        end

        # CVE-2026-4868: Validate identity for workflow triggering
        #
        # @param triggering_user [User] The user attempting to trigger the workflow
        # @return [void]
        # @raise [SecurityError] if identity validation fails
        def validate_identity!(triggering_user)
          return if triggering_user == user || allowed_identity_delegation?(triggering_user)

          raise SecurityError,
                'User identity mismatch: triggering user does not match workflow user'
        end

        # CVE-2026-4868: Check if identity delegation is allowed
        #
        # This is a controlled mechanism that requires explicit configuration.
        #
        # @param delegating_user [User, nil] The user attempting delegation
        # @return [Boolean] true if delegation is allowed
        def allowed_identity_delegation?(delegating_user = nil)
          delegating_user ||= triggering_user
          return false unless delegating_user.is_a?(User) && user.is_a?(User)

          return false unless delegating_user.can?(:admin_duo_workflow, project)
          return false unless project.duo_workflow_settings&.allow_identity_delegation

          authorized_delegation?(delegating_user, user)
        end

        # CVE-2026-4868: Check if delegation is explicitly authorized
        #
        # @param delegating_user [User] The user attempting delegation
        # @param target_user [User] The target user for delegation
        # @return [Boolean] true if delegation is explicitly authorized
        def authorized_delegation?(delegating_user, target_user)
          return false unless delegating_user.is_a?(User) && target_user.is_a?(User)

          delegating_user.can?(:admin_all_resources)
        end

        # Validates that the triggering user is a member of the project
        #
        # @return [void]
        def triggering_user_belongs_to_project
          return unless triggering_user.is_a?(User) && project.is_a?(Project)

          return if project.team.member?(triggering_user)

          errors.add(:triggering_user, 'must be a member of the project')
        end

        # Validates that the user is a member of the project
        #
        # @return [void]
        def user_belongs_to_project
          return unless user.is_a?(User) && project.is_a?(Project)

          return if project.team.member?(user)

          errors.add(:user, 'must be a member of the project')
        end

        # Validates that the triggering user has the required authorization
        #
        # @return [void]
        def triggering_user_must_be_authorized
          return unless triggering_user.is_a?(User) && project.is_a?(Project)

          return if triggering_user.can?(:trigger_duo_workflow, project)

          errors.add(:triggering_user, 'does not have permission to trigger workflows')
        end

        # Sets the default status for new workflows
        #
        # @return [void]
        def set_default_status
          self.status ||= :active
        end

        # Sets the triggering user to the current user if not specified
        #
        # @return [void]
        def set_triggering_user
          return if triggering_user.present?

          self.triggering_user = user
        end

        # Logs workflow creation for audit purposes
        #
        # @return [void]
        def log_workflow_creation
          Rails.logger.info(
            class: self.class.name,
            action: 'workflow_created',
            workflow_id: id,
            user_id: user_id,
            triggering_user_id: triggering_user_id,
            project_id: project_id,
            workflow_class: workflow_class
          )
        end

        # Logs an error message with exception details
        #
        # @param message [String] The error message
        # @param exception [Exception] The exception object
        # @return [void]
        def log_error(message, exception)
          Rails.logger.error(
            class: self.class.name,
            message: message,
            exception: exception.class.name,
            exception_message: exception.message,
            workflow_id: id,
            backtrace: exception.backtrace&.first(10)
          )
        end

        # Logs a security event with details
        #
        # @param message [String] The security event message
        # @param exception [Exception] The exception object
        # @return [void]
        def log_security_event(message, exception)
          Rails.logger.warn(
            class: self.class.name,
            message: message,
            exception: exception.class.name,
            exception_message: exception.message,
            workflow_id: id,
            user_id: user_id,
            triggering_user_id: triggering_user_id,
            project_id: project_id,
            backtrace: exception.backtrace&.first(10)
          )
        end

        # Executes the workflow after successful triggering
        #
        # @return [Boolean] true if execution was successful
        def execute_workflow!
          # Placeholder for actual workflow execution logic
          # This should be implemented based on specific workflow requirements
          true
        end
      end
    end
  end
end