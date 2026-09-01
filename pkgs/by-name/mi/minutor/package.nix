{
  stdenv,
  lib,
  fetchFromGitHub,
  qt5,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "minutor";
  version = "26.1";

  src = fetchFromGitHub {
    owner = "mrkite";
    repo = "minutor";
    tag = finalAttrs.version;
    sha256 = "sha256-jz+3G1/4+QlUTRBOFKaTWPSBbJRcWDzFWsG+dqVFMBg=";
  };

  preConfigure = ''
    substituteInPlace minutor.pro \
      --replace-fail /usr "$out"
  '';

  nativeBuildInputs = [
    qt5.qmake
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    qt5.qtbase
    zlib
  ];

  meta = {
    description = "Easy to use mapping tool for Minecraft";
    maintainers = [ lib.maintainers.sternenseemann ];
    license = lib.licenses.bsd2;
    homepage = "https://seancode.com/minutor/";
    inherit (qt5.qtbase.meta) platforms;
    mainProgram = "minutor";
  };
})
