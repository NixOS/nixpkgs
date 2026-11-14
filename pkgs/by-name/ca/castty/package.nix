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
    hash = "sha256-GtcmVaaa6Fy1wzFIugz2HdxHQFeiQ2BzI7qhq/mOBF0=";
  };

  buildInputs = [
    libsoundio
    lame
  ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "PREFIX=$(out)"
  ];

  meta = {
    description = "CLI tool to record audio-enabled screencasts of your terminal, for the web";
    homepage = "https://github.com/dhobsd/castty";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ iblech ];
    platforms = lib.platforms.unix;
    mainProgram = "castty";
  };
}
