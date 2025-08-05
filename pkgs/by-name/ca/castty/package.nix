{
  stdenv,
  lib,
  fetchFromGitHub,
  libsoundio,
  lame,
}:

stdenv.mkDerivation {
  pname = "castty";
  version = "0-unstable-2020-11-10";

  src = fetchFromGitHub {
    owner = "dhobsd";
    repo = "castty";
    rev = "333a2bafd96d56cd0bb91577ae5ba0f7d81b3d99";
    sha256 = "0p84ivwsp8ds4drn0hx2ax04gp0xyq6blj1iqfsmrs4slrajdmqs";
  };

  buildInputs = [
    libsoundio
    lame
  ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "PREFIX=$(out)"
  ];

  meta = with lib; {
    description = "CLI tool to record audio-enabled screencasts of your terminal, for the web";
    homepage = "https://github.com/dhobsd/castty";
    license = licenses.bsd3;
    maintainers = with maintainers; [ iblech ];
    platforms = platforms.unix;
    mainProgram = "castty";
  };
}
