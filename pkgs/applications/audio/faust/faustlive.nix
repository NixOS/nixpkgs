{ stdenv, fetchFromGitHub
, llvm, qt48Full, qrencode, libmicrohttpd, libjack2, alsaLib, faust, curl
, bc, coreutils, which, libsndfile, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "faustlive";
  version = "2.5.4";
  src = fetchFromGitHub {
    owner = "grame-cncm";
    repo = "faustlive";
    rev = version;
    sha256 = "0npn8fvq8iafyamq4wrj1k1bmk4xd0my2sp3gi5jdjfx6hc1sm3n";
    fetchSubmodules = true;
  };

  buildInputs = [
    llvm qt48Full qrencode libmicrohttpd libjack2 alsaLib faust curl
    bc coreutils which libsndfile pkg-config
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  postPatch = "cd Build";

  installPhase = ''
    install -d "$out/bin"
    install -d "$out/share/applications"
    install FaustLive/FaustLive "$out/bin"
    install rsrc/FaustLive.desktop "$out/share/applications"
  '';

  meta = with stdenv.lib; {
    broken = true;
    description = "A standalone just-in-time Faust compiler";
    longDescription = ''
      FaustLive is a standalone just-in-time Faust compiler. It tries to bring
      together the convenience of a standalone interpreted language with the
      efficiency of a compiled language. It's ideal for fast prototyping.
    '';
    homepage = "http://faust.grame.fr/";
    license = licenses.gpl3;
  };
}
