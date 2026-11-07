{
  build-idris-package,
  fetchFromGitHub,
  contrib,
  lib,
}:
build-idris-package {
  pname = "iaia";
  version = "2017-11-10";

  idrisDeps = [ contrib ];

  src = fetchFromGitHub {
    owner = "sellout";
    repo = "Iaia";
    rev = "dce68d2b63a26dad7c94459773eae2d42686fa05";
    hash = "sha256-qRhKqurkCDrURuer54NA/yTIbkEKMZ5lNFyPjjZ0CQg=";
  };

  meta = {
    description = "Recursion scheme library for Idris";
    homepage = "https://github.com/sellout/Iaia";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
