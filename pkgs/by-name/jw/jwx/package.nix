{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "jwx";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "lestrrat-go";
    repo = "jwx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Kx22Km2sFwxMV2LNb0oRG7nJvTD+D7og9Hsswh+SOqk=";
  };

  vendorHash = "sha256-0ehf6+hW4Yxn1WgOLdOfaSf3zg/UTAlUHRENQD5J3Sw=";

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
