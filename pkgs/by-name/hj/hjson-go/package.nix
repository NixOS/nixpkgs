{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "hjson-go";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "hjson";
    repo = "hjson-go";
    rev = "v${version}";
    hash = "sha256-0xFTxnXMJA98+Y6gwO8zCDPQvLecG1qmbGAISCFMaPw=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Utility to convert JSON to and from HJSON";
    homepage = "https://hjson.github.io/";
    changelog = "https://github.com/hjson/hjson-go/releases/tag/v${version}";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.mit;
    mainProgram = "hjson-cli";
  };
}
