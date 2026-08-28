{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "jwx";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "lestrrat-go";
    repo = "jwx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gH0sVY1Op5QfgRmbhxXyWpHXnbFFORHq+ChKwguCax4=";
  };

  vendorHash = "sha256-1/8DMKoBjPZfRoqpZlhWH37unlyWJi2GZczSRt+8+ZA=";

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
