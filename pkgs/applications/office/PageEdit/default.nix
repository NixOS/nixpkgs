{ lib, mkDerivation, fetchFromGitHub, cmake, qtsvg, qtwebengine, qttranslations }:

mkDerivation rec {
  pname = "PageEdit";
  version = "1.9.20";

  src = fetchFromGitHub {
    owner = "Sigil-Ebook";
    repo = pname;
    rev = version;
    hash = "sha256-naoflFANeMwabbdrNL3+ndvEXYT4Yqf+Mo77HcCexHE=";
  };

  nativeBuildInputs = [ cmake qttranslations ];
  propagatedBuildInputs = [ qtsvg qtwebengine ];
  cmakeFlags = [ "-DINSTALL_BUNDLED_DICTS=0" ];

  meta = with lib; {
    description = "ePub XHTML Visual Editor";
    homepage = "https://sigil-ebook.com/pageedit/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.pasqui23 ];
    platforms = platforms.all;
  };
}
