{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "jwx";
  version = "3.0.8";

  src = fetchFromGitHub {
    owner = "lestrrat-go";
    repo = "jwx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IorB1Zga4cDdeQv2QTc0qKvefIysxLz8StWMyqAWrTs=";
  };

  vendorHash = "sha256-HXf6H3FF3N5xLlO2Ux5tuN/ompfzQTAytUdGPbURw44=";

  sourceRoot = "${finalAttrs.src.name}/cmd/jwx";

  meta = {
    description = " Implementation of various JWx (Javascript Object Signing and Encryption/JOSE) technologies";
    mainProgram = "jwx";
    homepage = "https://github.com/lestrrat-go/jwx";
    changelog = "https://github.com/lestrrat-go/jwx/blob/v${finalAttrs.version}/Changes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      arianvp
      flokli
    ];
  };
})
