{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "jwx";
  version = "3.0.7";

  src = fetchFromGitHub {
    owner = "lestrrat-go";
    repo = "jwx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vR7QsRAVdYmi7wYGsjuQiB1mABq5jx7mIRFiduJRReA=";
  };

  vendorHash = "sha256-fpjkaGkJUi4jrdFvrClx42FF9HwzNW5js3I5HNZChOU=";

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
