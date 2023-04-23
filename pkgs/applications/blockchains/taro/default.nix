{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "taro";
  version = "0.1.0-alpha";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "taro";
    rev = "v${version}";
    sha256 = "sha256-0kEdGHi+R9Ns3cVgHSpK/GMVqi8xU/xV831ogV2ErYM=";
  };

  vendorSha256 = "sha256-huQZy62lx82lmuCQ7RQ+7SLMJIBYKfXbw+2ZkswPXxw=";

  subPackages = [ "cmd/tarocli" "cmd/tarod" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Daemon for the Taro protocol specification";
    homepage = "https://github.com/lightninglabs/taro";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
