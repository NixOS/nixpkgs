{
  lib,
  buildGoModule,
  fetchFromGitea,
  gitMinimal,
  installShellFiles,
  nix-update-script,
  stdenv,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "gitea-cli";
  version = "2.0.0";

  __structuredAttrs = true;

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-htPrx0siz8G6Gt0wkoa9ACDSs+lQVWV731uzZtU43sw=";
  };

  vendorHash = "sha256-FqgHOt/gLPxE+A31sIqJKwNsiXpfmi/IPP+JHFG0/HY=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-X gitea.dev/cli/internal/version.Version=${finalAttrs.version}"
    "-X gitea.dev/cli/internal/version.Tags=nixpkgs"
  ];

  excludedPackages = [
    # skip internal docs generation tool
    "tools/cli-docs"
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  checkFlags = [
    # doesn't like custom version ldflag
    "-skip=^TestDetectInstallation$"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd gt \
      --bash <($out/bin/gt completion bash) \
      --fish <($out/bin/gt completion fish) \
      --powershell <($out/bin/gt completion powershell) \
      --zsh <($out/bin/gt completion zsh)

    installManPage --name gt.1 <($out/bin/gt man)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Gitea official CLI client";
    homepage = "https://gitea.com/gitea/cli";
    changelog = "https://gitea.com/gitea/cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      josh
      techknowlogick
    ];
    mainProgram = "gt";
  };
})
