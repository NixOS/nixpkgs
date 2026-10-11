{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rayfish";
  version = "0.5.8";
  src = fetchFromGitHub {
    owner = "rayfish";
    repo = "rayfish";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s1vLcyKwcjvlexDm1fLPB7jQKu52+dSEQNdR4se3/40=";
  };
  cargoHash = "sha256-+h+1J4HH8YMcfF65X0P38CbgVIR68XS2cC0v9Xz8T5I=";

  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [ installShellFiles ];

  # 20261001: minimal profile for darwin to run tests
  sandboxProfile = lib.optionalString stdenv.hostPlatform.isDarwin ''
    (allow file-read-data
      (subpath "/Library/Preferences/SystemConfiguration/NetworkInterfaces.plist")
    )
  '';

  checkFlags = lib.forEach (
    [
      # 20260909: `ssh::tests::**` tests require live ssh server to test functionality of embedded mesh ssh server
      "ssh::tests::a_session_knows_it_is_remote"
      "ssh::tests::a_signal_request_reaches_the_session_process"
      "ssh::tests::agent_forwarding_hands_the_session_a_socket_that_reaches_the_client"
      "ssh::tests::concurrent_channels_keep_their_own_output_and_pty"
      "ssh::tests::every_channel_on_one_connection_runs_its_command"
      "ssh::tests::session_env_takes_locale_and_drops_the_rest"
      "ssh::tests::an_authenticated_session_outlives_the_login_grace"
      "ssh::tests::keepalives_preserve_idle_sessions_and_close_unresponsive_clients"
      # 20260909: flaky test
      "cli::status::grouping_tests::a_connecting_group_counts_members_without_a_reachable_split"
      # 20261001: thread 'daemon::mdns::tests::toggles_detach_lookup_and_preserve_connection' (12742) panicked at src/daemon/mdns.rs:226:36:
      #  called `Result::unwrap()` on an `Err` value: failed to start mDNS discovery
      #  Caused by:
      #    0: Service 'mdns' error
      #    1: Cannot bind to IPv4 or IPv6
      "daemon::mdns::tests::toggles_detach_lookup_and_preserve_connection"
      # 20261006: removed in upstream as part of master (af928b371bd6b619d362187a85c50c705ed08c0e)
      "xcode_marketing_version_matches_cargo_package"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # 20261001: thread 'macos_logs::tests::closing_reader_stops_an_idle_child' (557481) panicked at src/macos_logs.rs:168:55:
      #   called `Result::unwrap()` on an `Err` value: start macOS log reader
      #   Caused by:
      #     Operation not permitted (os error 1)
      "macos_logs::tests::closing_reader_stops_an_idle_child"
      # 20261006: ... (6337324) panicked at src/daemon/mod.rs:2410:13:
      # assertion `left == right` failed: recovery after Idle
      #   left: true
      #   right: false
      "daemon::accept_handler_tests::disconnect_recovery_tests::deliberate_idle_disconnect_does_not_retry"
      # 20261006: ... (6337328) panicked at src/daemon/mod.rs:2410:13:
      # assertion `left == right` failed: recovery after Replaced
      #   left: true
      #   right: false
      "daemon::accept_handler_tests::disconnect_recovery_tests::retry_reuses_successor_that_arrives_during_backoff"
      "daemon::accept_handler_tests::disconnect_recovery_tests::stale_disconnect_preserves_ready_successor"
    ]
  ) (test: "--skip=${test}");

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ray \
      --bash <($out/bin/ray completions bash) \
      --fish <($out/bin/ray completions fish) \
      --zsh <($out/bin/ray completions zsh)
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Peer to peer (P2P) mesh VPN powered by Iroh";
    longDescription = ''
      **Your machines, on one private network, anywhere**. *Rayfish* is a peer-to-peer mesh VPN that lets your laptop, phone,
      server, and your friends' machines talk to each other as if they were all plugged into the same router, even when
      they're scattered across the world behind different NATs.
    '';
    homepage = "https://rayfish.xyz";
    changelog = "https://github.com/rayfish/rayfish/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      debtquity
    ];
    mainProgram = "ray";
  };
})
