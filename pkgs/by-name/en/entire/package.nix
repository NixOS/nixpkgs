{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  git,
  stdenv,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "entire";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "entireio";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BDke84xQ6t7W+BONQn7r8ZBENNr8oGv8mtJ5unyv0lA=";
  };

  vendorHash = "sha256-zgVdh80aNnvC1oMp/CS0nx4b1y9b0jwVKFotil6kQZ0=";

  postPatch = ''
    substituteInPlace go.mod --replace-fail "go 1.25.6" "go 1.25.5"
  '';

  subPackages = [ "cmd/entire" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/entireio/cli/cmd/entire/cli/buildinfo.Version=${finalAttrs.version}"
    "-X=github.com/entireio/cli/cmd/entire/cli/buildinfo.Commit=${finalAttrs.src.rev}"
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

  meta = {
    description = "CLI tool that captures AI agent sessions alongside git commits";
    longDescription = ''
      Entire hooks into your git workflow to capture AI agent sessions on every
      push. Sessions are indexed alongside commits, creating a searchable record
      of how code was written in your repo.
    '';
    homepage = "https://github.com/entireio/cli";
    changelog = "https://github.com/entireio/cli/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sheeeng
      squishykid
    ];
    mainProgram = "entire";
  };
})
