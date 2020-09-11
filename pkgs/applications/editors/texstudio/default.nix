{ lib, mkDerivation, fetchFromGitHub, qmake, qtbase, qtscript, qtsvg,
  wrapQtAppsHook, poppler, zlib, pkgconfig }:

mkDerivation rec {
  pname = "texstudio";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "${pname}-org";
    repo = pname;
    rev = version;
    sha256 = "1663lgl30698awa7fjplr8rjnf6capqvf8z80lzlnkfl5m9ph0jb";
  };

  nativeBuildInputs = [ qmake wrapQtAppsHook pkgconfig ];
  buildInputs = [ qtbase qtscript qtsvg poppler zlib ];

  qmakeFlags = [ "NO_APPDATA=True" ];

  meta = with lib; {
    description = "TeX and LaTeX editor";
    longDescription=''
      Fork of TeXMaker, this editor is a full fledged IDE for
      LaTeX editing with completion, structure viewer, preview,
      spell checking and support of any compilation chain.
    '';
    homepage = "http://texstudio.sourceforge.net";
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ ajs124 cfouche ];
  };
}
