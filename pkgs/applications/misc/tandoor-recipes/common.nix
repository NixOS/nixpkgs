{ lib, fetchFromGitHub }:
rec {
<<<<<<< HEAD
  version = "1.5.6";
=======
  version = "1.4.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-3sitrTaIRKmjx+5vWOQXE0/Gu0jJ8VCpOq2cZZVLrbk=";
  };

  yarnHash = "sha256-mZ8beCF+3mnpgKED0fP96RBbGbKNNXqEJkGSjgrEGBc=";
=======
    sha256 = "sha256-h424lUm/wmCHXkMW2XejogvH3wL/+J67cG4m8rIWM1U=";
  };

  yarnSha256 = "sha256-LJ0uL66tcK6zL8Mkd2UB8dHsslMTtf8wQmgbZdvOT6s=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://tandoor.dev/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ambroisie ];
  };
}
