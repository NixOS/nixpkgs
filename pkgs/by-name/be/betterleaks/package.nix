{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
  gitMinimal,
}:

buildGoModule (finalAttrs: {
  pname = "betterleaks";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "betterleaks";
    repo = "betterleaks";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PJGFvm+QoExUMliL6rvBAKKjt8Ce5VZfQxCYbpXUXfU=";
  };

  vendorHash = "sha256-lIblIctRnq//ic+most3g9Ff92XhfqbFfHrLdI0beQQ=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/betterleaks/betterleaks/version.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
    versionCheckHook
  ];

  nativeCheckInputs = [ gitMinimal ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd betterleaks \
      --bash <($out/bin/betterleaks completion bash) \
      --fish <($out/bin/betterleaks completion fish) \
      --zsh <($out/bin/betterleaks completion zsh)
  '';

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Scan git repos (or files) for secrets";
    longDescription = ''
      Betterleaks is a secrets scanner that detects passwords, API keys, and
      tokens in git repositories and files. It is a drop-in replacement for
      gitleaks, built by the same authors with improved performance and
      additional detection features.
    '';
    homepage = "https://github.com/betterleaks/betterleaks";
    changelog = "https://github.com/betterleaks/betterleaks/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kallevmercury ];
    mainProgram = "betterleaks";
  };
})
