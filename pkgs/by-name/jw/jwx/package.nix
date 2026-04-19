{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "jwx";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "lestrrat-go";
    repo = "jwx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b/Bc+pZeFbdqB/Sp0bGvDU/MHE0r1rPPcj96SHdfcAg=";
  };

  vendorHash = "sha256-RBv86IfoCQDeQQfTU74oLpMOwU0JRJc0dcr3VMKX8CA=";

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
