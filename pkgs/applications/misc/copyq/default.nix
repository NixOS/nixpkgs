{ stdenv, fetchFromGitHub, cmake, qtbase, qtscript, qtwebkit, libXfixes, libXtst
, qtx11extras, git
, webkitSupport ? true
}:

stdenv.mkDerivation rec {
  name = "CopyQ-${version}";
  version = "3.6.1";

  src  = fetchFromGitHub {
    owner = "hluk";
    repo = "CopyQ";
    rev = "v${version}";
    sha256 = "0drhafnr1d595wa8zwvmgmrrqb86navdk4iw6ly6gmh0i800wz0z";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    git qtbase qtscript libXfixes libXtst qtx11extras
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
