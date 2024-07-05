{ lib, fetchFromGitHub }:
rec {
  version = "1.5.16";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    rev = version;
    hash = "sha256-A5cPO3uybTmAV8zWY90S9vtU/tLgbh1Iqhi+ty0RLhM=";
  };

  yarnHash = "sha256-OAgVaXWTVlKqIgDgKNT1MWN3dYzTqrAGgNAnXLDHE+I=";

  meta = with lib; {
    homepage = "https://tandoor.dev/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ambroisie ];
  };
}
