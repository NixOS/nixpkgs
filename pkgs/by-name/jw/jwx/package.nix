{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "jwx";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "lestrrat-go";
    repo = "jwx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZVI32z1hUquDUWdaLZGtI0PncboVHx2FJ3BB4MAhX0w=";
  };

  vendorHash = "sha256-vyqsUZ7IxXI6LZKrSOPxheE/IISKRC0wXB7+xj51xLM=";

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
