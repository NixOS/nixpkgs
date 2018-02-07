{ stdenv, fetchFromGitHub, cmake, qtbase, qtscript, qtwebkit, libXfixes, libXtst, git
, webkitSupport ? true
}:

stdenv.mkDerivation rec {
  name = "CopyQ-${version}";
  version = "3.1.2";

  src  = fetchFromGitHub {
    owner = "hluk";
    repo = "CopyQ";
    rev = "v${version}";
    sha256 = "0gdx1bqqqr4fk6wcrxqm9li6z48j1w84wjwyjpzp2cjzg96bp6bl";
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
