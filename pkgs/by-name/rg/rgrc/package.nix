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
  version = "0.6.30";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lazywalker";
    repo = "rgrc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZQzXd3xjhjTPLG6zmr3MfaAJu8eGPvs8/7U4CX7v2f8=";
  };

  cargoHash = "sha256-JA+gY4eKKv5yOijyVoQ9ubYd5Xf1UrKEO31RYLoTPEE=";

  buildFeatures = [ "embed-configs" ];
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
