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
  version = "0.6.13";

  src = fetchFromGitHub {
    owner = "lazywalker";
    repo = "rgrc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MZ3+dgq78QcroHJ0eL7kUuI+wZm6QaTCgA4CrcO5iCQ=";
  };

  cargoHash = "sha256-DB3J3fTesC8Eg/GqWLYKIiE8FoNjGs9i1LgNx4klvsw=";

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
