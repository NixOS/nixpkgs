{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.99.1";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-UzuKy3pwl+chwYUWtcUEJIrU8wpSg3o2mVryc3qA9EM=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-RaZ+yEkzsu/V3734joWtVA2m2vCOW+CnjF5s0mwDI/0=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
