{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.109.2";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-IVT3BWyDijhpt+bMn7u2f2JiGc0onAjbajHMzzbVt20=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-+m7XOpKzg0clbRh2Rpi8JqhLoJLJsA7tT3g6FkmoVc4=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
