{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "jwx";
  version = "3.0.13";

  src = fetchFromGitHub {
    owner = "lestrrat-go";
    repo = "jwx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f2L78kS0H3FxS/qS0hP+GUXjkH3teJ1L5rrzy1oq+Wk=";
  };

  vendorHash = "sha256-BGxLwALZ6PZiErbIngaJCUjBhkg3UbfZig/MMOgAZTQ=";

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
