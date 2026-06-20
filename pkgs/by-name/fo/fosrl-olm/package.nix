{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "olm";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "olm";
    tag = finalAttrs.version;
    hash = "sha256-USwTaQd8Aqq1Azsp4fXz3xSoxiqzYRSnUoBiqrepOXY=";
  };

  vendorHash = "sha256-+KQpYGoyNI2SnEjj23GM0FqZFX6lHx7oNw9qdkkgcPU=";

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;

  __structuredAttrs = true;

  meta = {
    description = "Tunneling client for Pangolin";
    homepage = "https://github.com/fosrl/olm";
    changelog = "https://github.com/fosrl/olm/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      jackr
      water-sucks
    ];
    mainProgram = "olm";
  };
})
