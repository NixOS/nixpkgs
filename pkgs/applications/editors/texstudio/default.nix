{ stdenv, fetchFromGitHub, qt5, poppler_qt5, zlib, pkgconfig}:

stdenv.mkDerivation rec {
  pname = "texstudio";
  version = "2.12.8";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "${pname}-org";
    repo = pname;
    rev = version;
    sha256 = "0f1az7398rnxmm3m9b2jcz7pd9x445fjsv8w85k2j261n5cyfqx2";
  };

  nativeBuildInputs = [ qt5.qmake pkgconfig ];
  buildInputs = [ qt5.qtbase qt5.qtscript qt5.qtsvg poppler_qt5 zlib ];

  qmakeFlags = [ "NO_APPDATA=True" ];

  meta = with stdenv.lib; {
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
