{
  lib,
  fetchFromGitHub,
  rustPlatform,
  R,
}:

rustPlatform.buildRustPackage rec {
  pname = "ark";
  version = "0.1.250";

  src = fetchFromGitHub {
    owner = "posit-dev";
    repo = "ark";
    tag = version;
    hash = "sha256-JX9WKzsFsPn8t6l0SQWJjemYsaFjU2nut9sbBb1QK8g=";
  };

  cargoHash = "sha256-bAHRLGTO4HtrbxLatPXfxFI2ePHovwYeMGY1G+vb3ho=";

  buildAndTestSubdir = "crates/ark";

  nativeBuildInputs = [ R ];

  useNextest = true;

  checkFlags = [
    # Failed Japanese characters truncation and emoji shifted
    "--skip data_explorer::format::tests::test_truncation"
    "--skip test_execute_request_srcref_location_with_emoji_utf8_shift"
    # Test involved Positron's internal setup
    "--skip modules::tests::test_environments_are_not_locked_in_debug"
    "--skip test_session_init_hook_new"
    # Required R 'Matrix' package, could not set R_LIBS_SITE in nextest
    "--skip variables::variable::tests::test_s4_with_different_length"
    # Required R 'glue' package, could not set R_LIBS_SITE in nextest
    "--skip test_dap_hit_count_with_log_message"
    "--skip test_kernel_request_priority_over_idle_tasks"
    "--skip test_multiple_pending_tasks_do_not_swallow_output"
    "--skip test_pending_idle_task_does_not_swallow_autoprint"
    "--skip test_pending_idle_task_does_not_swallow_stderr"
    "--skip test_pending_idle_task_does_not_swallow_stdout"
  ];

  meta = {
    description = "R kernel for Jupyter applications";
    homepage = "https://github.com/posit-dev/ark";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Th1nkK1D ];
  };
}
