{
  stdenv,
  lib,
  fetchFromGitea,
  autoconf,
  automake,
  libtool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soundtouch";
  version = "2.4.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "soundtouch";
    repo = "soundtouch";
    rev = finalAttrs.version;
    hash = "sha256-7JUBAFURKtPCZrcKqL1rOLdsYMd7kGe7wY0JUl2XPvw=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
  ];

  preConfigure = "./bootstrap";

  enableParallelBuilding = true;

  meta = {
    description = "Program and library for changing the tempo, pitch and playback rate of audio";
    homepage = "https://www.surina.net/soundtouch/";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
    mainProgram = "soundstretch";
    platforms = lib.platforms.all;
  };
})
