{stdenv, fetchurl, wxGTK, perl, python, zlib, mesa, libX11}:
let
  s = # Generated upstream information
  rec {
    baseName="golly";
    version="2.8";
    name="${baseName}-${version}";
    hash="0a4vn2hm7h4b47v2iwip1z3n9y8isf79v08aipl2iqms2m3p5204";
    url="mirror://sourceforge/project/golly/golly/golly-2.8/golly-2.8-src.tar.gz";
    sha256="0a4vn2hm7h4b47v2iwip1z3n9y8isf79v08aipl2iqms2m3p5204";
  };
  buildInputs = [
    wxGTK perl python zlib mesa libX11
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
