{
  lib,
  stdenv,
  fetchFromGitHub,
  installFonts,
}:

stdenv.mkDerivation {
  pname = "crimson-pro";
  version = "0-unstable-2022-08-30";

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchFromGitHub {
    owner = "Fonthausen";
    repo = "CrimsonPro";
    rev = "24e8f7bf59ec45d77c67879ad80d97e5f94c787b";
    hash = "sha256-3zFB1AMcC7eNEVA2Mx1OE8rLN9zPzexZ3FtER9wH5ss=";
  };

  postPatch = ''
    rm Makefile
  '';

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "https://github.com/Fonthausen/CrimsonPro";
    description = "Professionally produced redesign of Crimson by Jacques Le Bailly";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ncfavier ];
  };
}
