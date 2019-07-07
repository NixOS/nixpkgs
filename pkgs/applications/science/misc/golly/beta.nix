{stdenv, fetchgit
, wxGTK, perl, python2, zlib, libGLU_combined, libX11
, automake, autoconf
}:

stdenv.mkDerivation rec {
  pname = "golly";
  version = "2.8.99.2.20161122";
  #src = fetchurl {
  #  url="mirror://sourceforge/project/golly/golly/golly-2.8/golly-2.8-src.tar.gz";
  #  sha256="0a4vn2hm7h4b47v2iwip1z3n9y8isf79v08aipl2iqms2m3p5204";
  #};
  src = fetchgit {
    url = "git://git.code.sf.net/p/golly/code";
    rev = "93495edf3c9639332c6eb43ca7149c69629ee5d8";
    sha256 = "1j308s9zlqkr3wnl1l32s5zk7r3g4ijwawkkysl8j5ik9sibi2gk";
  };

  setSourceRoot = ''
    export sourceRoot="$(echo */gui-wx/configure)"
  '';

  nativeBuildInputs = [autoconf automake];

  buildInputs = [
    wxGTK perl python2 zlib libGLU_combined libX11
  ];

  # Link against Python explicitly as it is needed for scripts
  makeFlags=[
    "AM_LDFLAGS="
  ];
  NIX_LDFLAGS="-l${python2.libPrefix} -lperl -ldl -lGL";
  preConfigure=''
    export NIX_LDFLAGS="$NIX_LDFLAGS -L$(dirname "$(find ${perl} -name libperl.so)")"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE
      -DPYTHON_SHLIB=$(basename "$(
        readlink -f ${python2}/lib/libpython*.so)")"

    sh autogen.sh
  '';

  meta = {
    inherit version;
    description = "Cellular automata simulation program";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    downloadPage = "https://sourceforge.net/projects/golly/files/golly";
  };
}
