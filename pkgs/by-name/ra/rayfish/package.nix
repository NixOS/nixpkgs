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
  version = "0.4.1";
  src = fetchFromGitHub {
    owner = "rayfish";
    repo = "rayfish";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IUt5zkfBFuVURXErb1PgqRVBS7W1oli259FQnJnGL38=";
  };
  cargoHash = "sha256-4du+r2lC5FJ9nQGGxRKMT1ENMkYBplZasboLULp2yOM=";

  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [ installShellFiles ];

  checkFlags = lib.forEach [
    # 20260909: `ssh::tests::**` tests require live ssh server to test functionality of embedded mesh ssh server
    "ssh::tests::a_session_knows_it_is_remote"
    "ssh::tests::a_signal_request_reaches_the_session_process"
    "ssh::tests::agent_forwarding_hands_the_session_a_socket_that_reaches_the_client"
    "ssh::tests::concurrent_channels_keep_their_own_output_and_pty"
    "ssh::tests::every_channel_on_one_connection_runs_its_command"
    "ssh::tests::session_env_takes_locale_and_drops_the_rest"
    # 20260909: flaky test
    "cli::status::grouping_tests::a_connecting_group_counts_members_without_a_reachable_split"
  ] (test: "--skip=${test}");

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
    description = "Person to person (P2P) mesh VPN powered by Iroh";
    longDescription = ''
      **Your machines, on one private network, anywhere**. *Rayfish* is a peer-to-peer mesh VPN that lets your laptop, phone,
      server, and your friends' machines talk to each other as if they were all plugged into the same router, even when
      they're scattered across the world behind different NATs.

      There's nothing to host and nothing to sign up for. You don't rent a server, open a port, or hand out IP addresses.
      One person runs a command, shares a code, and the network exists.

      ## Why Rayfish

      - **No infrastructure.** There's no control server to host or trust. Peers find each other through a DHT and connect
        directly. The only "server" is whoever ran `ray create`, and they can be offline once everyone's admitted.
      - **Identity, not IP.** Every machine has a cryptographic identity, and its addresses are derived from that identity:
        stable, collision-free, and assigned without any coordinator handing them out.
      - **Private by default.** Networks are closed unless you say otherwise. The code you share to discover a network isn't
        enough to join it.
      - **Works over NAT.** Hole-punching and end-to-end encryption come from [iroh](https://iroh.computer), including automatic
        port mapping (UPnP/NAT-PMP/PCP). When a direct path isn't possible (roughly 10% of the time), traffic falls back to
        encrypted relays. For routers that block automatic port mapping, the daemon listens on a fixed UDP port (41383) you
        can manually forward to guarantee a direct path. A manual forward maps the port to one machine, so only one node per LAN
        benefits; the others still use automatic traversal and relay fallback.
      - **Reach peers by name.** Magic DNS gives you `name.network.ray` so you never memorize a virtual IP.

      ## Features

      - Refer to upstream [README.md](https://github.com/rayfish/rayfish/blob/${finalAttrs.src.tag}/README.md#features)
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
