{ stdenv, fetchFromGitHub
, llvm, qt48Full, qrencode, libmicrohttpd, libjack2, alsaLib, faust, curl
, bc, coreutils, which
}:

stdenv.mkDerivation rec {
  name = "faustlive-${version}";
  version = "2017-12-05";
  src = fetchFromGitHub {
    owner = "grame-cncm";
    repo = "faustlive";
    rev = "281fcb852dcd94f8c57ade1b2a7a3937542e1b2d";
    sha256 = "0sw44yd9928rid9ib0b5mx2x129m7zljrayfm6jz6hrwdc5q3k9a";
  };

  buildInputs = [
    llvm qt48Full qrencode libmicrohttpd libjack2 alsaLib faust curl
    bc coreutils which
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  preBuild = "patchShebangs Build/Linux/buildversion";

  meta = with stdenv.lib; {
    description = "A standalone just-in-time Faust compiler";
    longDescription = ''
      FaustLive is a standalone just-in-time Faust compiler. It tries to bring
      together the convenience of a standalone interpreted language with the
      efficiency of a compiled language. It's ideal for fast prototyping.
    '';
    homepage = http://faust.grame.fr/;
    license = licenses.gpl3;
  };
}
