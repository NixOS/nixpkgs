{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "btcd";
  version = "0.26.2";

  src = fetchFromGitHub {
    owner = "btcsuite";
    repo = "btcd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0FTWF+9lOLcSCyyvh8SDayikgOKeNO2R64SOHl4lh6s=";
  };

  vendorHash = "sha256-U9Mk642wMhz/Ld/9e7FKjPm7jGR8toQB+bQi/z4GHiA=";

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
