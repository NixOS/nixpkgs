{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "killport";
  version = "2.0.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-I8GsTSCbWRItQ4Hzens2KlsHZNM/boipT392xYL4wmg=";
  };

  cargoHash = "sha256-NOgt2WdS5JqTlCOI6qTOyBkTs/0qoA4qXoOHuZdRKvM=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  checkFlags = [
    # assertion failed: re.is_match(data) or blocked by sandbox
    "--skip=test_mode_option"
    "--skip=test_signal_handling"
    "--skip=test_signal_sig"
    "--skip=test_mode_short_flag"
    "--skip=test_mode_process_finds_process"
    "--skip=test_kill_udp_process"
    "--skip=test_mode_auto_finds_process"
    "--skip=test_kill_tcp_ipv4_process"
    "--skip=test_dry_run_with_signal"
    "--skip=test_combined_flags"
    "--skip=test_dry_run_does_not_kill"
    "--skip=test_dry_run_option"
    "--skip=test_basic_kill_process"
    "--skip=test_unix_process_kill_"
    "--skip=macos::tests::test_find_target_processes"
  ];

  # Most tests fail in sandboxed build on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    description = "Command-line tool to easily kill processes running on a specified port";
    homepage = "https://github.com/jkfran/killport";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tbutter ];
    mainProgram = "killport";
  };
})
