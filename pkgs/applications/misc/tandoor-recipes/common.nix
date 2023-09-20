{ lib, fetchFromGitHub }:
rec {
  version = "1.5.6";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    rev = version;
    hash = "sha256-3sitrTaIRKmjx+5vWOQXE0/Gu0jJ8VCpOq2cZZVLrbk=";
  };

  yarnHash = "sha256-mZ8beCF+3mnpgKED0fP96RBbGbKNNXqEJkGSjgrEGBc=";

  meta = with lib; {
    homepage = "https://tandoor.dev/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ambroisie ];
  };
}
