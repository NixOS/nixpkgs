{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.105.2";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-uoMjV0ab/H8WXWawWM9CB/mGTh9odrfmKehRz6A9/Xo=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-HlnnWmjYL/j5RvRKFtEE4ib477erA94aQ+HSF+sCiuA=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
