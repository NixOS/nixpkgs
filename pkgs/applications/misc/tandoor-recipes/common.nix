{ lib, fetchFromGitHub }:
rec {
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    rev = version;
    sha256 = "sha256-1wqZoOT2Aafbs2P0mL33jw5HkrLIitUcRt6bQQcHx40=";
  };

  yarnSha256 = "sha256-gH0q3pJ2BC5pAU9KSo3C9DDRUnpypoyLOEqKSrkxYrk=";

  meta = with lib; {
    homepage = "https://tandoor.dev/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ambroisie ];
  };
}
