{stdenv, fetchurl, wxGTK, perl, python2, zlib, libGLU_combined, libX11}:
stdenv.mkDerivation rec {
  baseName="golly";
  version = "3.1";
  name="${baseName}-${version}";

  src = fetchurl {
    sha256 = "0dn74k3rylhx023n047lz4z6qrqijfcxi0b6jryqklhmm2n532f7";
    url="mirror://sourceforge/project/golly/golly/golly-${version}/golly-${version}-src.tar.gz";
  };

  buildInputs = [
    wxGTK perl python2 zlib libGLU_combined libX11
  ];

  setSourceRoot = ''
    sourceRoot=$(echo */gui-wx/configure)
  '';

  # Link against Python explicitly as it is needed for scripts
  makeFlags=[
    "AM_LDFLAGS="
  ];
  NIX_LDFLAGS="-lpython${python2.majorVersion} -lperl";
  preConfigure=''
    export NIX_LDFLAGS="$NIX_LDFLAGS -L$(dirname "$(find ${perl} -name libperl.so)")"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE
      -DPYTHON_SHLIB=$(basename "$(
        readlink -f ${python2}/lib/libpython*.so)")"
  '';

  meta = {
    inherit version;
    description = "Cellular automata simulation program";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    downloadPage = "http://sourceforge.net/projects/golly/files/golly";
  };
}
