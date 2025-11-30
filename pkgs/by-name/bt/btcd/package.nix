{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "btcd";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "btcsuite";
    repo = "btcd";
    rev = "v${version}";
    hash = "sha256-redoqqbiVdwgNLxDzBccqRBZGwhRTIY5nE9Gx6+4POc=";
  };

  vendorHash = "sha256-qXfZKVoTvq7gNm0G4KKSL8anB8FUt/TxoxbOtH240cc=";

  subPackages = [
    "."
    "cmd/*"
  ];

  preCheck = ''
    DIR="github.com/btcsuite/btcd/"
    # TestCreateDefaultConfigFile requires the sample-btcd.conf in $DIR
    mkdir -p $DIR
    cp sample-btcd.conf $DIR
  '';

  meta = {
    description = "Alternative full node bitcoin implementation written in Go (golang)";
    homepage = "https://github.com/btcsuite/btcd";
    changelog = "https://github.com/btcsuite/btcd/releases/tag/v${version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ _0xB10C ];
  };
}
