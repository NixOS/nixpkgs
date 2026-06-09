{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "jwx";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "lestrrat-go";
    repo = "jwx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CGBQF//smVUt1/SQkxvZJ+7zlAhAuxVtO3WWWHCSvII=";
  };

  vendorHash = "sha256-g+kawcxLJdR77kkR6pJoRKe48kV+/kS33gYjOY30pAc=";

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
