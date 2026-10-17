{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "jwx";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "lestrrat-go";
    repo = "jwx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yP6XUGgcjyAEoUMOIknwgsI4MRqhJ74zEbIMtqIauFE=";
  };

  vendorHash = "sha256-r/CDxn57GfajCI2m1XAj17KowJIohutBZBdxt3YZ7H8=";

  sourceRoot = "${finalAttrs.src.name}/cmd/jwx";

  env.GOEXPERIMENT = "jsonv2";

  meta = {
    description = "Implementation of various JWx (Javascript Object Signing and Encryption/JOSE) technologies";
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
