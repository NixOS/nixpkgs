{ stdenv, fetchFromGitHub, qt5, poppler, zlib, pkgconfig}:

stdenv.mkDerivation rec {
  pname = "texstudio";
  version = "2.12.10";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "${pname}-org";
    repo = pname;
    rev = version;
    sha256 = "0mkx7fym41hwd7cdg31ji2hxlv3gxx0sa6bnap51ryxmq8sxdjhq";
  };

  nativeBuildInputs = [ qt5.qmake pkgconfig ];
  buildInputs = [ qt5.qtbase qt5.qtscript qt5.qtsvg poppler zlib ];

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
