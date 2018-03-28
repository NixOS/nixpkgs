{ stdenv, fetchFromGitHub, cmake, qtbase, qtscript, qtwebkit, libXfixes, libXtst, git
, webkitSupport ? true
}:

stdenv.mkDerivation rec {
  name = "CopyQ-${version}";
  version = "3.3.0";

  src  = fetchFromGitHub {
    owner = "hluk";
    repo = "CopyQ";
    rev = "v${version}";
    sha256 = "0j46h87ifinkydi0m725p422m9svk3dpcz8dnrci4mxx0inn6qs3";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    git qtbase qtscript libXfixes libXtst
  ] ++ stdenv.lib.optional webkitSupport qtwebkit;

  meta = with stdenv.lib; {
    homepage    = https://hluk.github.io/CopyQ;
    description = "Clipboard Manager with Advanced Features";
    license     = licenses.gpl3;
    maintainers = [ maintainers.willtim ];
    # NOTE: CopyQ supports windows and osx, but I cannot test these.
    # OSX build requires QT5.
    platforms   = platforms.linux;
  };
}
