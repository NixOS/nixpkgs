{ lib, mkDerivation, fetchFromGitHub, cmake
, qtbase, qtscript, qtwebkit, libXfixes, libXtst, qtx11extras, git
, webkitSupport ? true
}:

mkDerivation rec {
  pname = "CopyQ";
  version = "3.9.3";

  src  = fetchFromGitHub {
    owner = "hluk";
    repo = "CopyQ";
    rev = "v${version}";
    sha256 = "0wlwq9xg8rzsbj0b29z358k4mbrqy04iraa8x0p26pa95yskgcma";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    git qtbase qtscript libXfixes libXtst qtx11extras
  ] ++ lib.optional webkitSupport qtwebkit;

  meta = with lib; {
    homepage    = https://hluk.github.io/CopyQ;
    description = "Clipboard Manager with Advanced Features";
    license     = licenses.gpl3;
    maintainers = [ maintainers.willtim ];
    # NOTE: CopyQ supports windows and osx, but I cannot test these.
    # OSX build requires QT5.
    platforms   = platforms.linux;
  };
}
