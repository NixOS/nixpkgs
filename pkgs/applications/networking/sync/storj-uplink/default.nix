{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.104.1";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-wB8SK91eJp+8Jjc/bfMqDQQC3FYtSLEjpqVdxEq9P3c=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-Eo6JHcTcfC8zmKZh9sXrZ90RhIgdEBgTldIUnvNm8ms=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
