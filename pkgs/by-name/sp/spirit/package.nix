{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule {
  pname = "spirit";
  version = "unstable-2023-12-15";

  src = fetchFromGitHub {
    owner = "cashapp";
    repo = "spirit";
    rev = "3abce3e15c01b18e7a9fc12e19ad5c0f541d1ffd";
    hash = "sha256-B4z5bdb0hRx7U2RLTRDxRYt1ltACNXz/B6qAs4qjtAo=";
  };

  vendorHash = "sha256-hKTQvTWd48mnVODWE6W541TPuxCyELLgpz96XB29kec=";

  subPackages = [ "cmd/spirit" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/cashapp/spirit";
    description = "Online schema change tool for MySQL";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "spirit";
  };
}
