{
  lib,
  bashInteractive,
  fetchFromGitHub,
  gitMinimal,
  installShellFiles,
  ncurses,
  nix-update-script,
  nixosTests,
  openssl,
  zstd,
  sqlite,
  pkg-config,
  rustPlatform,
  stdenv,
  writableTmpDirAsHomeHook,
  writeShellScriptBin,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "atuin";
  version = "18.23.0";

  src = fetchFromGitHub {
    owner = "atuinsh";
    repo = "atuin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NBn7C9ssLSXYrHWv5qWM5dZ2E8URbRJZOOCvHaNgxW4=";
  };

  cargoHash = "sha256-rkDDs8gviBpoLR4mrrKRu2eTlmlpvjICVRFu22AeOaU=";

  # atuin's default features include 'check-updates', which do not make sense
  # for distribution builds. List all other default features.
  # see https://github.com/atuinsh/atuin/blob/main/crates/atuin/Cargo.toml#L42
  buildNoDefaultFeatures = true;
  buildFeatures = [
    "ai"
    "client"
    "clipboard"
    "daemon"
    "pty-proxy"
    "sync"
  ];

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    openssl
    zstd
    sqlite
  ];

  # e2e_pty tests drive an interactive bash (needs readline), run `clear`,
  # and create git repositories for workspace filtering
  nativeCheckInputs = [
    bashInteractive
    gitMinimal
    ncurses
    writableTmpDirAsHomeHook
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd atuin \
      --bash <($out/bin/atuin gen-completions -s bash) \
      --fish <($out/bin/atuin gen-completions -s fish) \
      --zsh <($out/bin/atuin gen-completions -s zsh)
  '';

  checkFlags = [
    # tries to make a network access
    "--skip=registration"
    "--skip=api_client"
    # No such file or directory (os error 2)
    "--skip=sync"
    # PermissionDenied (Operation not permitted)
    "--skip=change_password"
    "--skip=multi_user_test"
  ];

  # The e2e tests start an interactive bash, which sources the host's
  # /etc/bashrc when the build is not sandboxed (the darwin default).
  # The nix-darwin config resets PATH, so if the user has atuin installed,
  # the shell integration runs the system atuin instead of the one currently building
  # and no output is captured.
  # The test harness clears the environment before it starts the shell, so
  # NOSYSBASHRC has to be set by the shell it is given. It must be named bash:
  # the pty proxy picks the shell integration from the file name.
  env.ATUIN_E2E_BASH = lib.getExe (
    writeShellScriptBin "bash" ''
      NOSYSBASHRC=1 exec ${lib.getExe bashInteractive} "$@"
    ''
  );

  __darwinAllowLocalNetworking = true;

  passthru = {
    tests = {
      inherit (nixosTests) atuin atuin-programs;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Replacement for a shell history which records additional commands context with optional encrypted synchronization between machines";
    homepage = "https://github.com/atuinsh/atuin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      SuperSandro2000
      sciencentistguy
      _0x4A6F
      rvdp
    ];
    mainProgram = "atuin";
  };
})
