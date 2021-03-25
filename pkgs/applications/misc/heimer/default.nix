{ mkDerivation, lib, fetchFromGitHub, cmake, qttools, qtbase }:

mkDerivation rec {
  pname = "heimer";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "juzzlin";
    repo = pname;
    rev = version;
    sha256 = "sha256-upsOmf46bCO8sVp5dBHPLUBZYZP3JyXa7H5KXbd76qo=";
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
