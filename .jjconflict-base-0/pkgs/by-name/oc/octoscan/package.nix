{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "octoscan";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "synacktiv";
    repo = "octoscan";
    rev = "refs/tags/v${version}";
    hash = "sha256-65+ilS3v7CRcvw/SQANVzo3u/4GpjKxWTUD5M2xqXlc=";
  };

  vendorHash = "sha256-Jx4OEVqCTiW/BSygeLtwwqijiACEuPk0BT26JQoL3Ds=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Static vulnerability scanner for GitHub action workflows";
    homepage = "https://github.com/synacktiv/octoscan";
    changelog = "https://github.com/synacktiv/octoscan/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "octoscan";
  };
}
