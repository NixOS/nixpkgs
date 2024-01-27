{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.94.2";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-q2QLsbJSVnRch4CIlGI2Thuz0OOpGURIdy1BEKxUZ1A=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-UGx5pGfS7jWn7Uwjg1Gf/oQ3GbRTh5JSb38uPjxdUxc=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
