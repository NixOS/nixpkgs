{ lib, fetchFromGitHub }:
rec {
  version = "1.5.19";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    rev = version;
    hash = "sha256-HsBy2HzxBpnwh2RqFQJG0HYReWI0a7E7KsJ5TD+GokY=";
  };

  yarnHash = "sha256-BnOw9QRXRRoM+CW6OGbjWhLo4h6JX3ZR1kJd8Z/w02M=";

  meta = with lib; {
    homepage = "https://tandoor.dev/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ambroisie ];
  };
}
