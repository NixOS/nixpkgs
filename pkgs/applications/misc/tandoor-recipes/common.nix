{ lib, fetchFromGitHub }:
rec {
  version = "1.4.9";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    rev = version;
    sha256 = "sha256-h424lUm/wmCHXkMW2XejogvH3wL/+J67cG4m8rIWM1U=";
  };

  yarnSha256 = "sha256-LJ0uL66tcK6zL8Mkd2UB8dHsslMTtf8wQmgbZdvOT6s=";

  meta = with lib; {
    homepage = "https://tandoor.dev/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ambroisie ];
  };
}
