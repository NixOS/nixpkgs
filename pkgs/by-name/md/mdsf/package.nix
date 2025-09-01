{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
let
  pname = "mdsf";
  version = "0.10.5";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "hougesen";
    repo = "mdsf";
    tag = "v${version}";
    hash = "sha256-m7VoGozJShEw6qVXScxgX7CCyIh62unVvzjq/W7Ynu8=";
  };

  cargoHash = "sha256-AMo2LPC6RviYu2qx202o0gFIIJdjNJxS/zY06TEcpKw=";

  checkFlags = [
    # Failing due to the method under test trying to create a directory & write to the filesystem
    "--skip=caching::test_cache_entry::it_should_work"
    # Permissions denied due to the test trying to remove a directory
    "--skip=commands::prune_cache::test_run::it_should_remove_cache_directory"
    # Permissions denied due to the test trying to write to a file
    "--skip=config::test_config::it_should_error_on_broken_config"
    # The following tests try to create tmp files
    "--skip=format::accepts_multiple_file_paths"
    "--skip=format::accepts_multiple_file_paths_with_thread_argument"
    "--skip=format::accepts_multiple_file_paths_with_thread_argument_zero"
    "--skip=format::format_with_cache_arg"
    "--skip=format::formats_broken_input"
    "--skip=format::formats_broken_input_stdin"
    "--skip=format::formats_broken_input_with_debug_arg"
    "--skip=format::on_missing_tool_binary_fail_cli"
    "--skip=format::on_missing_tool_binary_fail_config"
    "--skip=format::on_missing_tool_binary_fail_fast_cli"
    "--skip=format::on_missing_tool_binary_fail_fast_config"
    "--skip=format::on_missing_tool_binary_ignore_cli"
    "--skip=format::on_missing_tool_binary_ignore_config"
    "--skip=format::on_missing_tool_binary_prioritize_cli"
    "--skip=format::supports_config_path_argument"
    # Depends on one of gofumpt, gofmt, or crlfmt being available
    "--skip=test_lib::it_should_add_go_package_if_missing"
    # The following tests depend on rustfmt being available
    "--skip=test_lib::it_should_format_the_code"
    "--skip=test_lib::it_should_format_the_codeblocks_that_start_with_whitespace"
    "--skip=test_lib::it_should_not_care_if_go_package_is_set"
    "--skip=test_lib::it_should_not_modify_outside_blocks"
    # The following tests try to interact with the file system
    "--skip=verify::accepts_multiple_file_paths_broken"
    "--skip=verify::accepts_multiple_file_paths_mixed"
    "--skip=verify::fails_with_broken_input"
    # The following tests try to interact with stdin
    "--skip=verify::success_with_formatted_input_stdin"
    "--skip=verify::supports_log_level_argument"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Format markdown code blocks using your favorite tools";
    homepage = "https://github.com/hougesen/mdsf";
    changelog = "https://github.com/hougesen/mdsf/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "mdsf";
  };
}
