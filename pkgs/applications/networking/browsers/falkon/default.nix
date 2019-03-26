{ stdenv, lib, fetchFromGitHub, cmake, extra-cmake-modules, pkgconfig, qmake
, libpthreadstubs, libxcb, libXdmcp
, qtsvg, qttools, qtwebengine, qtx11extras
, qtwayland
, kwallet
}:

stdenv.mkDerivation rec {
  pname = "falkon";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner  = "KDE";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1ay1ljrdjcfqwjv4rhf4psh3dfihnvhpmpqcayd3p9lh57x7fh41";
  };

  preConfigure = ''
    export NONBLOCK_JS_DIALOGS=true
    export KDE_INTEGRATION=true
    export GNOME_INTEGRATION=false
    export FALKON_PREFIX=$out
  '';

  buildInputs = [
    libpthreadstubs libxcb libXdmcp
    qtsvg qttools qtwebengine qtx11extras
    kwallet
  ] ++ lib.optionals stdenv.isLinux [ qtwayland ];

  nativeBuildInputs = [ cmake extra-cmake-modules pkgconfig qmake qttools ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "QtWebEngine based cross-platform web browser";
    homepage    = https://www.falkon.org/;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.unix;
  };
}
