{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  gitUpdater,
  versionCheckHook,
}:
# Temporary until buildGoModule updates to 1.27
buildGo127Module (finalAttrs: {
  pname = "gopodder";
  version = "1.4.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cbrgm";
    repo = "gopodder";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bOxLXvT9vb0aOFHZuBEse2KwSRw03dg2QguTudODDas=";
  };

  vendorHash = "sha256-KMDgJHAjvYr2P991jGYx9gNIx2GU3d7eYhO/RlvYGZI=";

  dontPatchELF = true;

  ldflags = [
    "-X main.Version=${finalAttrs.version}"
    "-X main.Revision=${finalAttrs.src.tag}"
    "-X main.BuildDate=1970-01-01"
  ];

  env.CGO_ENABLED = 0;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    description = "Self-hostable podcast synchronization server compatible with the gPodder API";
    homepage = "https://github.com/cbrgm/gopodder";
    changelog = "https://github.com/cbrgm/gopodder/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nielmin ];
    mainProgram = "gopodder";
  };
})
