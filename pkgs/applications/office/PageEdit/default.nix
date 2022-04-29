{ lib, mkDerivation, fetchFromGitHub, cmake, qtsvg, qtwebengine, qttranslations }:

mkDerivation rec {
  pname = "PageEdit";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "Sigil-Ebook";
    repo = pname;
    rev = version;
    hash = "sha256-/t08ZS2iYWIDkco0nhACBQs1X+X77SJ/g+ow7KemfRY=";
  };

  nativeBuildInputs = [ cmake qttranslations ];
  propagatedBuildInputs = [ qtsvg qtwebengine ];
  cmakeFlags = "-DINSTALL_BUNDLED_DICTS=0";

  meta = with lib; {
    description = "ePub XHTML Visual Editor";
    homepage = "https://sigil-ebook.com/pageedit/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.pasqui23 ];
    platforms = platforms.all;
  };
}
