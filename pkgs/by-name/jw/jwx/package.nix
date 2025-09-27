{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "jwx";
  version = "3.0.11";

  src = fetchFromGitHub {
    owner = "lestrrat-go";
    repo = "jwx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TGB6dMybvMH/mXlNwnj63kOrj56mbEFTQSVfphnQJfY=";
  };

  vendorHash = "sha256-7lMvSwLi588UBI31YDi/VqyAqwUjWUwjOZbxE3fZQWU=";

  sourceRoot = "${finalAttrs.src.name}/cmd/jwx";

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
