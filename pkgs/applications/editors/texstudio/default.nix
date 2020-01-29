{ lib, mkDerivation, fetchFromGitHub, qmake, qtbase, qtscript, qtsvg,
  wrapQtAppsHook, poppler, zlib, pkgconfig }:

mkDerivation rec {
  pname = "texstudio";
  version = "2.12.20";

  src = fetchFromGitHub {
    owner = "${pname}-org";
    repo = pname;
    rev = version;
    sha256 = "0hywx2knqdrslzmm4if476ryf4ma0aw5j8kdp6lyrz2jx7az2gqa";
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
    homepage = http://texstudio.sourceforge.net;
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ cfouche ];
  };
}
