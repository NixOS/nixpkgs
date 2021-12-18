{ mkDerivation, lib, fetchFromGitHub, cmake, qttools, qtbase }:

mkDerivation rec {
  pname = "heimer";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "juzzlin";
    repo = pname;
    rev = version;
    sha256 = "sha256-Q1a+sGZTVUjViakBT3E7+AgqMSldAnp7UJcsSS6KZXs=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qttools qtbase ];

  meta = with lib; {
    description = "Simple cross-platform mind map and note-taking tool written in Qt";
    homepage = "https://github.com/juzzlin/Heimer";
    license = licenses.gpl3;
    maintainers  = with maintainers; [ dtzWill ];
    platforms = platforms.linux;
  };
}
