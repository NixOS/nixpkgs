{
  fetchFromGitHub,
  installShellFiles,
  lib,
  nix-update-script,
  rustPlatform,
  stdenv,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rgrc";
  version = "0.6.9";

  src = fetchFromGitHub {
    owner = "lazywalker";
    repo = "rgrc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Sc0JmcnxW9WZ78ayJtSWTZBoVgqnFGUO2dKGi8U05S0=";
  };

  cargoHash = "sha256-wEE08Rqga5Ffz6IgYyQto0gB8bXCZ6Myc3r6uM5XTCs=";

  nativeBuildInputs = [ installShellFiles ];

  checkFlags = [ "--skip=test_command_exists" ];

  postInstall = ''
    installManPage doc/rgrc.1
    install -Dm644 share/conf.* -t $out/share/rgrc/
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd rgrc \
      --bash <($out/bin/rgrc --completions bash) \
      --fish <($out/bin/rgrc --completions fish) \
      --zsh <($out/bin/rgrc --completions zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/lazywalker/rgrc/releases/tag/v${finalAttrs.version}";
    description = "Rusty Generic Colouriser - just like grc but fast";
    homepage = "https://lazywalker.github.io/rgrc/";
    license = lib.licenses.mit;
    mainProgram = "rgrc";
    maintainers = with lib.maintainers; [ sedlund ];
  };
})
