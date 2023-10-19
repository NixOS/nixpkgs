{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "taproot-assets";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "taproot-assets";
    rev = "v${version}";
    hash = "sha256-NDTxkdqzTGrKylxQxq4gj93j5Rsioo+39jdGJ/+F09E=";
  };

  vendorHash = "sha256-w4VkKq6fYiFy5LUMyfCwpJTYA9mFjZLIwB3jfcla+rc=";

  subPackages = [ "cmd/tapcli" "cmd/tapd" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Daemon for the Taro protocol specification";
    homepage = "https://github.com/lightninglabs/taro";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
