{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.93.2";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-3q3z5dYFjBpBbwj64Kp2fiTmxn2PUgc0DGJBMR71yN0=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-1K74yoMMeMzjldMjZVmmCJRrLYBrVmmOgqqCA1CBzrQ=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
