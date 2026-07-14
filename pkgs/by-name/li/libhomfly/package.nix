{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  boehmgc,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.04";
  pname = "libhomfly";

  src = fetchFromGitHub {
    owner = "miguelmarco";
    repo = "libhomfly";
    rev = finalAttrs.version;
    hash = "sha256-ND2ZBKwHlRYTqxC+ltkCQ2lolNAkhZZm5hriIaOLqC4=";
  };

  buildInputs = [
    boehmgc
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/miguelmarco/libhomfly/";
    description = "Library to compute the homfly polynomial of knots and links";
    license = lib.licenses.unlicense;
    teams = [ lib.teams.sage ];
    platforms = lib.platforms.all;
  };
})
