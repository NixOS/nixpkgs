{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "sic";
  version = "1.3";

  src = fetchurl {
    url = "https://dl.suckless.org/tools/sic-${version}.tar.gz";
    hash = "sha256-MEePqz68dfLrXQjLtbL+3K9IkRbnWi3XGX4+nHM9ZdI=";
  };

  makeFlags = [ "CC:=$(CC)" ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Simple IRC client";
    mainProgram = "sic";
    homepage = "https://tools.suckless.org/sic/";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
