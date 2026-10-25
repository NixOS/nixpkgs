{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
}:

buildGoModule (finalAttrs: {
  pname = "adalanche";
  version = "2024.1.11";

  src = fetchFromGitHub {
    owner = "lkarlslund";
    repo = "adalanche";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SJa2PQCXTYdv5jMucpJOD2gC7Qk2dNdINHW4ZvLXSLw=";
  };

  vendorHash = "sha256-3HulDSR6rWyxvImWBH1m5nfUwnUDQO9ALfyT2D8xmJc=";

  # The collectors are for Windows only.
  excludedPackages = [
    "collector"
    "localmachine/collect"
  ];

  buildInputs = [
    libpcap
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/lkarlslund/adalanche/modules/version.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "Active Directory ACL Visualizer and Explorer";
    homepage = "https://github.com/lkarlslund/adalanche";
    changelog = "https://github.com/lkarlslund/Adalanche/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "adalanche";
  };
})
