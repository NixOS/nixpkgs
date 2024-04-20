{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.102.2";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-GpHX34iHKeoT7AuEf76QTpTIrATLZyAoUxMoIouhvyA=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-atIb/SmOShLIhvEsTcegX7+xoDXN+SI5a7TQrXpqdUg=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
