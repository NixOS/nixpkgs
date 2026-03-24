{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "olm";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "olm";
    tag = finalAttrs.version;
    hash = "sha256-2FqtucYOfnyOcsEivhZFh18gofcqCGOMhPrr2V91OAM=";
  };

  vendorHash = "sha256-D93SPwXAeoTLCbScjyH8AB9TJIF2b/UbLNMIQYi+B+c=";

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;

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
