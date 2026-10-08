{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  versionCheckHook,
  which,
}:

buildGoModule (finalAttrs: {
  pname = "scmpuff";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "mroth";
    repo = "scmpuff";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PrnZYk0moWH46AT5njQPk7kVOQaktwVbOGMAX307tyY=";
  };

  vendorHash = "sha256-Uu3tZhIoYPq4QWc63Y5cPNa+MZtFklwuZyUc0CJLlXc=";

  preCheck = ''
    substituteInPlace \
      internal/cmd/inits/data/status_shortcuts.sh \
      internal/cmd/inits/data/status_shortcuts.fish \
      --replace-fail /usr/bin/env env
  '';

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

  nativeCheckInputs = [
    gitMinimal
    which
  ];

  strictDeps = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Numeric file shortcuts for common git commands";
    homepage = "https://github.com/mroth/scmpuff";
    changelog = "https://github.com/mroth/scmpuff/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      cpcloud
      christoph-heiss
    ];
    mainProgram = "scmpuff";
  };
})
