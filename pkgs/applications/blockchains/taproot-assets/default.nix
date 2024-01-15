{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "taproot-assets";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "taproot-assets";
    rev = "v${version}";
    hash = "sha256-zYS/qLWYzfmLksYLCUWosT287K8La2fuu9TcT4Wytto=";
  };

  vendorHash = "sha256-jz6q3l2FtkJM3qyaTTqqu3ZG2FeKW9s7WdlW1pHij5k=";

  subPackages = [ "cmd/tapcli" "cmd/tapd" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Daemon for the Taro protocol specification";
    homepage = "https://github.com/lightninglabs/taro";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
