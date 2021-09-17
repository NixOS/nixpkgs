{ lib, stdenv, fetchFromGitHub
, llvm_10, qt5, qrencode, libmicrohttpd, libjack2, alsa-lib, faust, curl
, bc, coreutils, which, libsndfile, pkg-config, libxcb
}:

stdenv.mkDerivation rec {
  pname = "faustlive";
  version = "2.5.5";
  src = fetchFromGitHub {
    owner = "grame-cncm";
    repo = "faustlive";
    rev = version;
    sha256 = "0qbn05nq170ckycwalkk5fppklc4g457mapr7p7ryrhc1hwzffm9";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config qt5.wrapQtAppsHook ];

  buildInputs = [
    llvm_10 qt5.qtbase qrencode libmicrohttpd libjack2 alsa-lib faust curl
    bc coreutils which libsndfile libxcb
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
    maintainers = with maintainers; [ magnetophon ];
  };
}
