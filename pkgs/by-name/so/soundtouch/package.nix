{
  stdenv,
  lib,
  fetchFromGitea,
  autoconf,
  automake,
  libtool,
}:

stdenv.mkDerivation rec {
  pname = "soundtouch";
  version = "2.4.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "soundtouch";
    repo = "soundtouch";
    rev = version;
    hash = "sha256-7JUBAFURKtPCZrcKqL1rOLdsYMd7kGe7wY0JUl2XPvw=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
  ];

  preConfigure = "./bootstrap";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Program and library for changing the tempo, pitch and playback rate of audio";
    homepage = "https://www.surina.net/soundtouch/";
    license = licenses.lgpl21Plus;
    maintainers = [ ];
    mainProgram = "soundstretch";
    platforms = platforms.all;
  };
}
