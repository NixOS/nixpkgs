{ stdenv, fetchFromGitHub, cmake, qt5, libXfixes, libXtst, git
, webkitSupport ? true
}:

stdenv.mkDerivation rec {
  name = "CopyQ-${version}";
  version = "3.0.3";

  src  = fetchFromGitHub {
    owner = "hluk";
    repo = "CopyQ";
    rev = "v${version}";
    sha256 = "0wpxqrg4mn8xjsrwsmlhh731s2kr6afnzpqif1way0gi7fqr73jl";
  };

  patches = [
    ./cmake-modules.patch
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    git qt5.full libXfixes libXtst
  ] ++ stdenv.lib.optional webkitSupport qt5.qtwebkit;

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
