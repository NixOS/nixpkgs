{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  rustPlatform,
  nixosTests,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "atuin";
  version = "18.8.0";

  src = fetchFromGitHub {
    owner = "atuinsh";
    repo = "atuin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FJEXIxdeg6ExXvrQ3dtugMK5xw+NwWyB+ld9rj7okoU=";
  };

  cargoHash = "sha256-xJPSMu22Bq9Panrafsd5vUSnEQYuJB19OEZaAq8z0mw=";

  # atuin's default features include 'check-updates', which do not make sense
  # for distribution builds. List all other default features.
  buildNoDefaultFeatures = true;
  buildFeatures = [
    "client"
    "sync"
    "server"
    "clipboard"
    "daemon"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd atuin \
      --bash <($out/bin/atuin gen-completions -s bash) \
      --fish <($out/bin/atuin gen-completions -s fish) \
      --zsh <($out/bin/atuin gen-completions -s zsh)
  '';

  passthru = {
    tests = {
      inherit (nixosTests) atuin;
    };
    updateScript = nix-update-script { };
  };

  checkFlags = [
    # tries to make a network access
    "--skip=registration"
    # No such file or directory (os error 2)
    "--skip=sync"
    # PermissionDenied (Operation not permitted)
    "--skip=change_password"
    "--skip=multi_user_test"
    "--skip=store::var::tests::build_vars"
    # Tries to touch files
    "--skip=build_aliases"
  ];

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
