{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "btcd";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "btcsuite";
    repo = "btcd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RgoUbHpIujBM6AkqBsR406V/20OUrXYelyqfTPXI0j4=";
  };

  vendorHash = "sha256-p99OSye1UowSY3v+SUUyKv8NHGciWcd5sHYAwlDc2WI=";

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
