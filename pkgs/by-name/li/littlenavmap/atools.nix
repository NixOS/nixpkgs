{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
}:

stdenv.mkDerivation rec {
  pname = "atools";
  version = "4.0.17";

  src = fetchFromGitHub {
    owner = "albar965";
    repo = "atools";
    tag = "v${version}";
    hash = "sha256-R5CbMdT8UsPiiIXFhmdAmNa1fKLPfUrWunlbwsHOVow=";
  };

  nativeBuildInputs = [
    libsForQt5.qmake
  ];

  buildInputs = [
    libsForQt5.qtsvg
  ];

  env.ATOOLS_NO_CRASHHANDLER = "true";

  installTargets = "deploy";

  postInstall = ''
    rmdir $out
    mv D/atools $out
  '';

  dontWrapQtApps = true;

  meta = {
    description = "Static library extending Qt for exception handling, a log4j like logging framework, Flight Simulator related utilities like BGL reader and more";
    homepage = "https://github.com/albar965/atools";
    changelog = "https://github.com/albar965/atools/blob/${src.rev}/CHANGELOG.txt";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ck3d ];
    platforms = lib.platforms.all;
  };
}
