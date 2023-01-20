{ lib, fetchFromGitHub }:
rec {
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    rev = version;
    sha256 = "sha256-Q/IwjSByCUXVYxhk3U7oWvlMxrJxyajhpsRyq67PVHY=";
  };

  yarnSha256 = "sha256-gH0q3pJ2BC5pAU9KSo3C9DDRUnpypoyLOEqKSrkxYrk=";

  meta = with lib; {
    homepage = "https://tandoor.dev/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ambroisie ];
  };
}
