{ lib, fetchFromGitHub }:
rec {
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    rev = version;
    sha256 = "sha256-cVrgmRDzuLzl2+4UcrLRdrP6ZFWMkavu9OEogNas2fA=";
  };

  yarnSha256 = "sha256-0u9P/OsoThP8gonrzcnO5zhIboWMI1mTsXHlbt7l9oE=";

  meta = with lib; {
    homepage = "https://tandoor.dev/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ambroisie ];
  };
}
