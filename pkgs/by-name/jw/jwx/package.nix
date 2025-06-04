{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "jwx";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "lestrrat-go";
    repo = "jwx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IKMTRgxqGZkYK5WVWUjIrjed6ukphHzbmtXOwoJSkRo=";
  };

  vendorHash = "sha256-mqPlub5JbD7dcMHi72xda72HQJF57uqzHaJzYOQNk+Q=";

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
