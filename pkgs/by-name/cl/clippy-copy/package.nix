{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "clippy-copy";
  version = "1.6.9";

  src = fetchFromGitHub {
    owner = "neilberkman";
    repo = "clippy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8OdT+R4dvJCLhelIAsAgVoWGGwmWueTsiJFpCm1uQEc=";
  };

  vendorHash = "sha256-7do+KgoiIocS+mq2hsgv3NOd+TjMl2I9ew2Emx3/Bbg=";

  ldflags = [
    "-s"
    "-X=github.com/neilberkman/clippy/cmd/internal/common.Version=${finalAttrs.version}"
    "-X=github.com/neilberkman/clippy/cmd/internal/common.Commit=${finalAttrs.src.tag}"
    "-X=github.com/neilberkman/clippy/cmd/internal/common.Date=1970-01-01T00:00:00Z"
  ];

  # Tests require access to the system clipboard (unavailable in sandbox)
  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "Clipboard tool supporting both text and binary files";
    homepage = "https://github.com/neilberkman/clippy";
    changelog = "https://github.com/neilberkman/clippy/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ m4r1vs ];
    mainProgram = "clippy";
    platforms = lib.platforms.darwin;
  };
})
