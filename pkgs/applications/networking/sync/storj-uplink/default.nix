{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.110.3";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-hVgFr5fnoSZumNkImMIEbKCu7nIAT72bMi3wnsn95tc=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-iXOL7YtSXTmLMS3nDvuUy2puWK83gbtVmrzD17C9JxU=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
