{stdenv, fetchurl, wxGTK, perl, python, zlib}:
let
  s = # Generated upstream information
  rec {
    baseName="golly";
    version="2.6";
    name="${baseName}-${version}";
    hash="1n1k3yf23ymlwq4k6p4v2g04qd29pg2rabr4l7m9bj2b2j1zkqhz";
    url="mirror://sourceforge/project/golly/golly/golly-2.6/golly-2.6-src.tar.gz";
    sha256="1n1k3yf23ymlwq4k6p4v2g04qd29pg2rabr4l7m9bj2b2j1zkqhz";
  };
  buildInputs = [
    wxGTK perl python zlib
  ];
in
stdenv.mkDerivation rec {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };

  sourceRoot="${name}-src/gui-wx/configure";

  # Link against Python explicitly as it is needed for scripts
  makeFlags=[
    "AM_LDFLAGS="
  ];
  NIX_LDFLAGS="-lpython${python.majorVersion} -lperl";
  preConfigure=''
    export NIX_LDFLAGS="$NIX_LDFLAGS -L$(dirname "$(find ${perl} -name libperl.so)")"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE
      -DPYTHON_SHLIB=$(basename "$(
        readlink -f ${python}/lib/libpython*.so)")"
  '';

  meta = {
    inherit (s) version;
    description = "Cellular automata simulation program";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    downloadPage = "http://sourceforge.net/projects/golly/files/golly";
  };
}
