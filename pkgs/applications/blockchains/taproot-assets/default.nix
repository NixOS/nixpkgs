{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "taproot-assets";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "taproot-assets";
    rev = "v${version}";
    hash = "sha256-sTLimar8cDWFl9lwQHYlKFL3CuNcy3p8CVbRjhrH+Dw=";
  };

  vendorHash = "sha256-IFzYW5vAtBoUC2ebFYnxS/TojQR4kXxQACNbyn2ZkCs=";

  subPackages = [ "cmd/tapcli" "cmd/tapd" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Daemon for the Taro protocol specification";
    homepage = "https://github.com/lightninglabs/taro";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
