{ lib, stdenv
  , fetchFromGitHub
  , autoreconfHook
  , pkg-config
  , perl
  , fribidi
  , kbd
  , xkbutils
}:

stdenv.mkDerivation rec {
  pname = "bicon";
  version = "unstable-2018-09-10";

  src = fetchFromGitHub {
    owner = "behdad";
    repo = pname;
    rev = "38725c062a83ab19c4e4b4bc20eb9535561aa76c";
    sha256 = "0hdslrci8pq300f3rrjsvl5psfrxdwyxf9g2m5g789sr049dksnq";
  };

  buildInputs = [ fribidi kbd xkbutils perl ];
  nativeBuildInputs = [ autoreconfHook pkg-config ];

  preConfigure = ''
    patchShebangs .
  '';

  meta = with lib; {
    description = "A bidirectional console";
    homepage =  "https://github.com/behdad/bicon";
    license = [ licenses.lgpl21 licenses.psfl licenses.bsd0 ];
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
