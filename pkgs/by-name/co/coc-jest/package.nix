{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage {
  pname = "coc-jest";
  version = "1.1.5-unstable-2025-04-19";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-jest";
    rev = "0ce2cd21c535e0c6c86102bc4da95337cb29948b";
    hash = "sha256-jEwQxZWyKh5tgdRD0f/jQ3q9B/fIGD9Pd8AYDsBj4LQ=";
  };

  patches = [
    ./package-lock-fix.patch
  ];

  npmDepsHash = "sha256-4X6lmblZnAF+4ZmrWYwfigO90Ah7I+B4tbMpFrguxMU=";

  npmBuildScript = "prepare";

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Jest extension for coc.nvim";
    homepage = "https://github.com/neoclide/coc-jest";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
