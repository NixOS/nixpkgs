ruby
# frozen_string_literal: true

module EE
  module Ai
    module DuoWorkflows
      class TriggerService
        # =============================================================================
        # Security Fix: CVE-2026-4868 - Improper User Identity Resolution
        # =============================================================================
        # This service handles triggering Duo AI workflow runners.
        # The vulnerability allowed an authenticated user to cause specific Duo AI
        # workflows to run under another user's identity due to improper user identity
        # resolution when triggering Duo AI workflow runners.
        #
        # Fix: Always resolve the user identity from the current context (current_user)
        # and never accept a user-controlled key for identity resolution.
        # =============================================================================

        # @!attribute [r] current_user
        #   @return [User, nil] the currently authenticated user
        # @!attribute [r] workflow
        #   @return [Workflow, nil] the workflow to trigger
        # @!attribute [r] params
        #   @return [Hash] the parameters for the workflow
        attr_reader :current_user, :workflow, :params

        # @param current_user [User, nil] the currently authenticated user
        # @param workflow [Workflow, nil] the workflow to trigger
        # @param params [Hash] the parameters for the workflow
        def initialize(current_user:, workflow:, params: {})
          @current_user = current_user
          @workflow = workflow
          @params = params.dup.freeze
        end

        # Main entry point for triggering a Duo AI workflow.
        #
        # @return [ServiceResponse] a ServiceResponse with success or error
        def execute
          validate_initial_state!
          validate_authorization!
          resolved_user = resolve_user_identity!
          runner_context = build_runner_context(resolved_user)
          trigger_workflow_runner(runner_context)
        rescue ::ActiveRecord::RecordNotFound => e
          log_error(e, level: :warn)
          error_response('Workflow not found')
        rescue ::Gitlab::Access::AccessDeniedError => e
          log_error(e, level: :warn)
          error_response('Access denied')
        rescue ::ArgumentError => e
          log_error(e, level: :warn)
          error_response('Invalid parameters')
        rescue ::StandardError => e
          log_error(e, level: :error)
          error_response('Failed to trigger workflow')
        end

        private

        # Validates the initial state of the service.
        #
        # @raise [ArgumentError] if current_user or workflow is invalid
        # @return [void]
        def validate_initial_state!
          raise ::ArgumentError, 'User not authenticated' unless current_user.present?
          raise ::ArgumentError, 'Invalid user' unless valid_user?(current_user)
          raise ::ArgumentError, 'Workflow not found' unless workflow.present?
          raise ::ArgumentError, 'Workflow not triggerable' unless workflow.triggerable?
        end

        # Validates authorization for the current user to trigger the workflow.
        #
        # @raise [Gitlab::Access::AccessDeniedError] if not authorized
        # @return [void]
        def validate_authorization!
          raise ::Gitlab::Access::AccessDeniedError unless authorized_to_trigger?
        end

        # =============================================================================
        # SECURITY-CRITICAL: User Identity Resolution
        # =============================================================================
        # The vulnerability was that user-controlled parameters could override the
        # identity used to run workflows. This method ensures we ALWAYS use the
        # authenticated current_user and NEVER trust user-supplied identifiers.
        # =============================================================================

        # Resolves the user identity for the workflow execution.
        #
        # SECURITY FIX: Always uses current_user, never params[:user_id] or similar.
        # Previously, the code might have done something like:
        #   User.find_by(id: params[:user_id]) || current_user
        # This allowed an attacker to specify a different user_id in params.
        #
        # @raise [ArgumentError] if user identity cannot be resolved
        # @return [User] the resolved user identity
        def resolve_user_identity!
          validate_user_active!
          validate_user_permissions!
          current_user
        end

        # Validates that the current user is active.
        #
        # @raise [ArgumentError] if user is not active
        # @return [void]
        def validate_user_active!
          raise ::ArgumentError, 'User account is not active' unless current_user.active?
        end

        # Validates that the current user has the required permissions.
        #
        # @raise [ArgumentError] if user lacks permissions
        # @return [void]
        def validate_user_permissions!
          unless current_user.can?(:use_duo_ai_workflows)
            raise ::ArgumentError, 'User does not have Duo AI workflows permission'
          end
        end

        # =============================================================================
        # Authorization Check
        # =============================================================================

        # Checks if the current user is authorized to trigger the workflow.
        #
        # @return [Boolean] true if authorized, false otherwise
        def authorized_to_trigger?
          return false unless current_user.can?(:trigger_duo_workflow, workflow)

          case workflow.workflow_type
          when 'code_review'
            current_user.can?(:trigger_code_review_workflow, workflow.project)
          when 'code_generation'
            current_user.can?(:trigger_code_generation_workflow, workflow.project)
          when 'documentation'
            current_user.can?(:trigger_documentation_workflow, workflow.project)
          else
            current_user.can?(:trigger_duo_workflow, workflow.project)
          end
        end

        # =============================================================================
        # Workflow Runner Context Building
        # =============================================================================

        # Builds the context for the workflow runner.
        #
        # @param user [User] the resolved user identity
        # @return [Hash] the runner context
        def build_runner_context(user)
          {
            user_id: user.id,
            username: user.username,
            workflow_id: workflow.id,
            workflow_type: workflow.workflow_type,
            project_id: workflow.project_id,
            workflow_params: sanitized_workflow_params,
            security_context: build_security_context(user)
          }
        end

        # Builds the security context for audit logging.
        #
        # @param user [User] the resolved user identity
        # @return [Hash] the security context
        def build_security_context(user)
          {
            triggered_by_user_id: current_user.id,
            triggered_by_username: current_user.username,
            resolved_user_id: user.id,
            resolved_username: user.username,
            timestamp: Time.current.iso8601,
            source_ip: current_user.current_sign_in_ip&.to_s
          }
        end

        # =============================================================================
        # Parameter Sanitization
        # =============================================================================

        # Sanitizes workflow parameters to only allow safe, expected keys.
        #
        # @return [Hash] the sanitized parameters
        def sanitized_workflow_params
          allowed_params = %i[workflow_type project_id ref branch commit_sha merge_request_id]
          params.slice(*allowed_params).tap do |sanitized|
            sanitized[:ref] = sanitize_ref(sanitized[:ref]) if sanitized[:ref]
            sanitized[:branch] = sanitize_branch(sanitized[:branch]) if sanitized[:branch]
            sanitized[:commit_sha] = sanitize_commit_sha(sanitized[:commit_sha]) if sanitized[:commit_sha]
          end
        end

        # Sanitizes a ref parameter to prevent injection attacks.
        #
        # @param ref [String] the ref to sanitize
        # @return [String] the sanitized ref
        def sanitize_ref(ref)
          ref.to_s.strip.gsub(/[^a-zA-Z0-9_\-\.\/]/, '')
        end

        # Sanitizes a branch parameter to prevent injection attacks.
        #
        # @param branch [String] the branch to sanitize
        # @return [String] the sanitized branch
        def sanitize_branch(branch)
          branch.to_s.strip.gsub(/[^a-zA-Z0-9_\-\.\/]/, '')
        end

        # Sanitizes a commit SHA parameter to prevent injection attacks.
        #
        # @param sha [String] the commit SHA to sanitize
        # @return [String] the sanitized commit SHA
        def sanitize_commit_sha(sha)
          sha.to_s.strip.gsub(/[^a-f0-9]/, '')
        end

        # =============================================================================
        # Workflow Triggering
        # =============================================================================

        # Triggers the workflow runner with the given context.
        #
        # @param runner_context [Hash] the context for the workflow runner
        # @return [ServiceResponse] a ServiceResponse with success or error
        def trigger_workflow_runner(runner_context)
          runner = find_or_create_runner(runner_context)
          result = runner.execute(runner_context)

          if result[:status] == :success
            log_info("Workflow triggered successfully", runner_context)
            success_response(result)
          else
            log_error("Workflow execution failed", runner_context)
            error_response(result[:message] || 'Workflow execution failed')
          end
        rescue ::StandardError => e
          log_error(e, runner_context)
          error_response('Failed to execute workflow runner')
        end

        # Finds or creates a workflow runner for the given context.
        #
        # @param runner_context [Hash] the context for the workflow runner
        # @return [WorkflowRunner] the workflow runner
        def find_or_create_runner(runner_context)
          runner_class = determine_runner_class(runner_context[:workflow_type])
          runner_class.find_or_create_by!(
            workflow_id: runner_context[:workflow_id],
            project_id: runner_context[:project_id]
          )
        rescue ::ActiveRecord::RecordNotFound => e
          log_error(e, runner_context)
          raise
        end

        # Determines the runner class based on workflow type.
        #
        # @param workflow_type [String] the type of workflow
        # @return [Class] the runner class
        def determine_runner_class(workflow_type)
          case workflow_type
          when 'code_review'
            ::Ai::DuoWorkflows::CodeReviewRunner
          when 'code_generation'
            ::Ai::DuoWorkflows::CodeGenerationRunner
          when 'documentation'
            ::Ai::DuoWorkflows::DocumentationRunner
          else
            ::Ai::DuoWorkflows::GenericRunner
          end
        end

        # =============================================================================
        # Response Handling
        # =============================================================================

        # Creates a success response.
        #
        # @param result [Hash] the result data
        # @return [ServiceResponse] a ServiceResponse with success
        def success_response(result)
          ::ServiceResponse.success(
            message: 'Workflow triggered successfully',
            payload: result
          )
        end

        # Creates an error response.
        #
        # @param message [String] the error message
        # @return [ServiceResponse] a ServiceResponse with error
        def error_response(message)
          ::ServiceResponse.error(
            message: message,
            http_status: :unprocessable_entity
          )
        end

        # =============================================================================
        # Logging
        # =============================================================================

        # Logs an informational message.
        #
        # @param message [String] the log message
        # @param context [Hash, nil] additional context for the log
        # @return [void]
        def log_info(message, context = nil)
          ::Gitlab::AppLogger.info(
            class: self.class.name,
            message: message,
            user_id: current_user&.id,
            workflow_id: workflow&.id,
            context: context
          )
        end

        # Logs an error message.
        #
        # @param message_or_error [String, Exception] the error message or exception
        # @param context [Hash, nil] additional context for the log
        # @param level [Symbol] the log level (:warn or :error)
        # @return [void]
        def log_error(message_or_error, context: nil, level: :error)
          if message_or_error.is_a?(::StandardError)
            ::Gitlab::AppLogger.send(level,
              class: self.class.name,
              message: message_or_error.message,
              backtrace: message_or_error.backtrace&.first(10),
              user_id: current_user&.id,
              workflow_id: workflow&.id,
              context: context
            )
          else
            ::Gitlab::AppLogger.send(level,
              class: self.class.name,
              message: message_or_error,
              user_id: current_user&.id,
              workflow_id: workflow&.id,
              context: context
            )
          end
        end

        # =============================================================================
        # Validation Helpers
        # =============================================================================

        # Validates that the user is a valid user object.
        #
        # @param user [User] the user to validate
        # @return [Boolean] true if valid, false otherwise
        def valid_user?(user)
          user.is_a?(::User) && user.persisted?
        end
      end
    end
  end
end