{ lib, stdenv, fetchFromGitHub
, llvm, qt48Full, qrencode, libmicrohttpd_0_9_70, libjack2, alsaLib, faust, curl
, bc, coreutils, which, libsndfile, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "faustlive";
  version = "unstable-dev-2020-08-03";
  src = fetchFromGitHub {
    owner = "grame-cncm";
    repo = "faustlive";
    rev = "c16565dc1b616ac0aad7c303c1997fa9e57177ab";
    sha256 = "1ys661lp1xwz21vy12kwkg248jvjq1z9w433knkh0ldyy2igvmd5";
    fetchSubmodules = true;
  };

  buildInputs = [
    llvm qt48Full qrencode libmicrohttpd_0_9_70 libjack2 alsaLib faust curl
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

  meta = with lib; {
    description = "A standalone just-in-time Faust compiler";
    longDescription = ''
      FaustLive is a standalone just-in-time Faust compiler. It tries to bring
      together the convenience of a standalone interpreted language with the
      efficiency of a compiled language. It's ideal for fast prototyping.
    '';
    homepage = "https://faust.grame.fr/";
    license = licenses.gpl3;
  };
}
