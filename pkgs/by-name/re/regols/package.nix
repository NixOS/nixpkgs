{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "regols";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "kitagry";
    repo = "regols";
    rev = "v${version}";
    hash = "sha256-1L9ehqTMN9KHlvE7FBccVAXA7f3NNsLXJaTkOChT8Xo=";
  };

  vendorHash = "sha256-yJYWVQq6pbLPdmK4BVse6moMkurlmt6TBd6/vYM1xcU=";

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "OPA Rego language server";
    mainProgram = "regols";
    homepage = "https://github.com/kitagry/regols";
    changelog = "https://github.com/kitagry/regols/releases/tag/${src.rev}";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alias-dev ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ alias-dev ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
