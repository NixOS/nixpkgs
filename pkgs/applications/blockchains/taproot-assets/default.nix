{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "taproot-assets";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "taproot-assets";
    rev = "v${version}";
    hash = "sha256-nTgIoYajpnlEvyXPcwXbm/jOfG+C83TTZiPmoB2kK24=";
  };

  vendorHash = "sha256-fc++0M7Mnn1nJOkV2gzAVRQCp3vOqsO2OQNlOKaMmB4=";

  subPackages = [ "cmd/tapcli" "cmd/tapd" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Daemon for the Taro protocol specification";
    homepage = "https://github.com/lightninglabs/taro";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
