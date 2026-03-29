{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "go-i2p";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "go-i2p";
    repo = "go-i2p";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Qu6fbVfe/ve0rCPgpc5gLev7qqLUYjuPCtOcsFbnAyA=";
  };

  vendorHash = null;

  meta = {
    description = "Go implementation of the I2P Router protocol";
    homepage = "https://go-i2p.github.io/go-i2p/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ VZstless ];
    mainProgram = "go-i2p";
  };
})
