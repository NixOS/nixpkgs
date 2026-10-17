{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  installShellFiles,
  git,
  stdenv,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

buildGo127Module (finalAttrs: {
  pname = "entire";
  version = "0.11.5";

  src = fetchFromGitHub {
    owner = "entireio";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MpTJt9HyEWkPGZIBST+iop0iCHHfy/4Hw3T5TmwB6Yo=";
  };

  vendorHash = "sha256-SgjJ2+eXUzN5YAafVII7Lgj9i2s1JDRBLanNNvhP0gA=";

  subPackages = [ "cmd/entire" ];

  ldflags = [
    "-s"
    "-X=github.com/entireio/cli/cmd/entire/cli/versioninfo.Version=${finalAttrs.version}"
    "-X=github.com/entireio/cli/cmd/entire/cli/versioninfo.Commit=${finalAttrs.src.rev}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [
    git
    writableTmpDirAsHomeHook
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd entire \
      --bash <($out/bin/entire completion bash) \
      --fish <($out/bin/entire completion fish) \
      --zsh <($out/bin/entire completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool that captures AI agent sessions alongside git commits";
    longDescription = ''
      Entire hooks into your git workflow to capture AI agent sessions on every
      push. Sessions are indexed alongside commits, creating a searchable record
      of how code was written in your repo.
    '';
    homepage = "https://github.com/entireio/cli";
    changelog = "https://github.com/entireio/cli/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      iamanaws
      sheeeng
      squishykid
    ];
    mainProgram = "entire";
  };
})
