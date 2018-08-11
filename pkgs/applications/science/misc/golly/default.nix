{stdenv, fetchurl, wxGTK, perl, python2, zlib, libGLU_combined, libX11}:
stdenv.mkDerivation rec {
  baseName="golly";
  version = "3.2";
  name="${baseName}-${version}";

  src = fetchurl {
    sha256 = "0cg9mbwmf4q6qxhqlnzrxh9y047banxdb8pd3hgj3smmja2zf0jd";
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
