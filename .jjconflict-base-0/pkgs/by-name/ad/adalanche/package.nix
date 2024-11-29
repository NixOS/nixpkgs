{ lib
, buildGoModule
, fetchFromGitHub
, libpcap
}:

buildGoModule rec {
  pname = "adalanche";
  version = "2024.1.11";

  src = fetchFromGitHub {
    owner = "lkarlslund";
    repo = "adalanche";
    rev = "refs/tags/v${version}";
    hash = "sha256-SJa2PQCXTYdv5jMucpJOD2gC7Qk2dNdINHW4ZvLXSLw=";
  };

  vendorHash = "sha256-3HulDSR6rWyxvImWBH1m5nfUwnUDQO9ALfyT2D8xmJc=";

  buildInputs = [
    libpcap
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/lkarlslund/adalanche/modules/version.Version=${version}"
  ];

  env = {
    CGO_CFLAGS = "-Wno-undef-prefix";
  };

  meta = with lib; {
    description = "Active Directory ACL Visualizer and Explorer";
    homepage = "https://github.com/lkarlslund/adalanche";
    changelog = "https://github.com/lkarlslund/Adalanche/releases/tag/v${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "adalanche";
  };
}
