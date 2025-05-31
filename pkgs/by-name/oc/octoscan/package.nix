{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "octoscan";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "synacktiv";
    repo = "octoscan";
    tag = "v${version}";
    hash = "sha256-SG6QHpDG9kPfb9jvHwz58U7+HZpFwYzwsDERNRW5R10=";
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
