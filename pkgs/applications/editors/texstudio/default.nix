{ lib, mkDerivation, fetchFromGitHub, qmake, qtbase, qtscript, qtsvg,
  wrapQtAppsHook, poppler, zlib, pkg-config }:

mkDerivation rec {
  pname = "texstudio";
  version = "4.2.2";

  src = fetchFromGitHub {
    owner = "${pname}-org";
    repo = pname;
    rev = version;
    sha256 = "sha256-MZz8DQT1f6RU+euEED1bbg2MsaqC6+W3RoMk2qfIjr4=";
  };

  nativeBuildInputs = [ qmake wrapQtAppsHook pkg-config ];
  buildInputs = [ qtbase qtscript qtsvg poppler zlib ];

  qmakeFlags = [ "NO_APPDATA=True" ];

  meta = with lib; {
    description = "TeX and LaTeX editor";
    longDescription=''
      Fork of TeXMaker, this editor is a full fledged IDE for
      LaTeX editing with completion, structure viewer, preview,
      spell checking and support of any compilation chain.
    '';
    homepage = "https://texstudio.org";
    changelog = "https://github.com/texstudio-org/texstudio/blob/${version}/utilities/manual/CHANGELOG.txt";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ajs124 cfouche ];
  };
}
