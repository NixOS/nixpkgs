{
  lib,
  mkDerivation,
  fetchFromGitHub,
  cmake,
  qttools,
  qtbase,
}:

mkDerivation rec {
  pname = "heimer";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "juzzlin";
    repo = pname;
    rev = version;
    hash = "sha256-eKnGCYxC3b7qd/g2IMDyZveBg+jvFA9s3tWEGeTPSkU=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    qttools
    qtbase
  ];

  meta = with lib; {
    description = "Simple cross-platform mind map and note-taking tool written in Qt";
    mainProgram = "heimer";
    homepage = "https://github.com/juzzlin/Heimer";
    changelog = "https://github.com/juzzlin/Heimer/blob/${version}/CHANGELOG";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
