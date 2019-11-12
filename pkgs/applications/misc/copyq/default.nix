{ lib, mkDerivation, fetchFromGitHub, cmake
, qtbase, qtscript, qtwebkit, libXfixes, libXtst, qtx11extras, git
, webkitSupport ? true
}:

mkDerivation rec {
  pname = "CopyQ";
  version = "3.9.2";

  src  = fetchFromGitHub {
    owner = "hluk";
    repo = "CopyQ";
    rev = "v${version}";
    sha256 = "02zs444i7hnqishs1i6vp8ffjxlxk3xkrw935pdwnwppv9s9v202";
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
