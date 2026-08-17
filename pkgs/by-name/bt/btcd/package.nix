{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "btcd";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "btcsuite";
    repo = "btcd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-08Ce66iSVCVzhSQ4fouWiXmld7e7jFU+Y1o8HdtsaDE=";
  };

  vendorHash = "sha256-vXQSFh9lD7iNjgUwhA4AMZ2miq/1pV8Y8QT7rcvgdCE=";

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
    changelog = "https://github.com/btcsuite/btcd/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ _0xB10C ];
  };
})
