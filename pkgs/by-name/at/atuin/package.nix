{
  lib,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  nixosTests,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "atuin";
  version = "18.19.0";

  src = fetchFromGitHub {
    owner = "atuinsh";
    repo = "atuin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P+57HkZ2Xl2sFBNw8zaaX91DF47DVQQswXAziu5h4NM=";
  };

  cargoHash = "sha256-15H0BwkJZ8Khu6H9K31VBxYRy8b/KhK32/b5kaxmRjw=";

  postPatch = ''
    substituteInPlace crates/atuin-pty-proxy/tests/{fd_pressure,subscriber}.rs \
      --replace-fail "/bin/cat" "cat"
  '';

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

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

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
