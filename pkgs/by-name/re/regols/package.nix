{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "regols";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "kitagry";
    repo = "regols";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1L9ehqTMN9KHlvE7FBccVAXA7f3NNsLXJaTkOChT8Xo=";
  };

  vendorHash = "sha256-yJYWVQq6pbLPdmK4BVse6moMkurlmt6TBd6/vYM1xcU=";

  meta = {
    description = "OPA Rego language server";
    mainProgram = "regols";
    homepage = "https://github.com/kitagry/regols";
    changelog = "https://github.com/kitagry/regols/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alias-dev ];
  };
})
