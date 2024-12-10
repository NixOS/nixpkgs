{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.118.8";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-kVV5d3ULRg/yGWZJSR2gP0X3gaGPM3Uy0ZkLed1Kb+U=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-5pNYC1ubjxaU7KPd4lsEOyAe/OU95UID4JtFJ6Q+E3w=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
