{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "scmpuff";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "mroth";
    repo = "scmpuff";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-c8F7BgjbR/w2JH8lE2t93s8gj6cWbTQGIkgYTQp9R3U=";
  };

  vendorHash = "sha256-7xSMToc5rlxogS0N9H6siauu8i33zUA5/omqXAszDOg=";

  ldflags = [
    "-s"
    "-w"
    # see .goreleaser.yml in the repository
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.src.rev}"
    "-X main.date=1970-01-01T00:00:00Z"
    "-X main.builtBy=nixpkgs"
    "-X main.treeState=clean"
  ];

  strictDeps = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = with lib; {
    description = "Numeric file shortcuts for common git commands";
    homepage = "https://github.com/mroth/scmpuff";
    changelog = "https://github.com/mroth/scmpuff/releases/tag/v${finalAttrs.version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      cpcloud
      christoph-heiss
    ];
    mainProgram = "scmpuff";
  };
})
