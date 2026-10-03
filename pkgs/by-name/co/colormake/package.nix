{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
}:

stdenv.mkDerivation {
  pname = "colormake";
  version = "2.1.0";

  buildInputs = [ perl ];

  src = fetchFromGitHub {
    owner = "pagekite";
    repo = "Colormake";
    rev = "66544f40d4626aace137c6a502b3c70b56c770c1";
    hash = "sha256-jnFMVUAwXRaZidk4fbrEe4ufss+0JK97zUEr/mhNxtc=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp -fa colormake.pl colormake colormake-short clmake clmake-short $out/bin
  '';

  meta = {
    description = "Simple wrapper around make to colorize the output";
    homepage = "https://bre.klaki.net/programs/colormake/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
  };
}
