{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "et-book";
  version = "0-unstable-2015-10-05";

  strictDeps = true;
  __structuredAttrs = true;

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchFromGitHub {
    owner = "edwardtufte";
    repo = "et-book";
    rev = "7e8f02dadcc23ba42b491b39e5bdf16e7b383031";
    hash = "sha256-B6ryC9ibNop08TJC/w9LSHHwqV/81EezXsTUJFq8xpo=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Typeface used in Edward Tufte’s books";
    homepage = "https://edwardtufte.github.io/et-book/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ jethro ];
  };
}
