{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "clippy-copy";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "neilberkman";
    repo = "clippy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gwhhH/b2Y8rqjFx2136xirZo0TFOO6Y3Vz6qGOf5Zog=";
  };

  vendorHash = "sha256-9za2KDUB4txYhJo0ezbLk6h8g6EYnxJhWWjzes+5IIg=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/neilberkman/clippy/cmd/internal/common.Version=${finalAttrs.version}"
    "-X=github.com/neilberkman/clippy/cmd/internal/common.Commit=${finalAttrs.src.tag}"
    "-X=github.com/neilberkman/clippy/cmd/internal/common.Date=1970-01-01T00:00:00Z"
  ];

  doCheck = false; # Tests won't run in build environment

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Clipboard tool supporting both text and binary files";
    homepage = "https://github.com/neilberkman/clippy";
    changelog = "https://github.com/neilberkman/clippy/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "clippy";
    platforms = lib.platforms.darwin;
  };
})
