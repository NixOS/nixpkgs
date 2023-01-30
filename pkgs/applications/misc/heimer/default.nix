{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, qttools
, qtbase
}:

mkDerivation rec {
  pname = "heimer";
  version = "3.6.4";

  src = fetchFromGitHub {
    owner = "juzzlin";
    repo = pname;
    rev = version;
    hash = "sha256-hKVBPSWIbKXMEmk9C7k+3NBqLwYybN6Jql9qigIx4jE=";
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
    homepage = "https://github.com/juzzlin/Heimer";
    changelog = "https://github.com/juzzlin/Heimer/blob/${version}/CHANGELOG";
    license = licenses.gpl3Plus;
    maintainers  = with maintainers; [ dtzWill ];
    platforms = platforms.linux;
  };
}
