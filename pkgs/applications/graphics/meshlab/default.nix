{stdenv, fetchurl, qt4, bzip2, lib3ds, levmar, muparser, unzip}:

stdenv.mkDerivation rec {
  name = "meshlab-1.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/meshlab/meshlab/MeshLab%20v1.3.2/MeshLabSrc_AllInc_v132.tgz";
    sha256 = "d57f0a99a55421aac54a66e2475d48f00f7b1752f9587cd69cf9b5b9c1a519b1";
  };

  # I don't know why I need this; without this, the rpath set at the beginning of the
  # buildPhase gets removed from the 'meshlab' binary
  dontPatchELF = true;

  # Patches are from the Arch Linux package
  patchPhase = ''
    patch -Np0 -i "${./qt-4.8.patch}"
    patch -Np1 -i "${./gcc-4.7.patch}"
  '';

  buildPhase = ''
    mkdir -p "$out/include"
    cp -r vcglib "$out/include"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$out/include/vcglib"
    export NIX_LDFLAGS="-rpath $out/opt/meshlab $NIX_LDFLAGS"
    cd meshlab/src
    pushd external
    qmake -recursive external.pro
    make
    popd
    qmake -recursive meshlab_full.pro
    make
  '';

  installPhase = ''
    mkdir -p $out/opt/meshlab $out/bin $out/lib
    pushd distrib
    cp -R * $out/opt/meshlab
    popd
    ln -s $out/opt/meshlab/meshlab $out/bin/meshlab
  '';

  sourceRoot = ".";

  buildInputs = [ qt4 unzip ];

  meta = {
    description = "System for the processing and editing of unstructured 3D triangular meshes";
    homepage = http://meshlab.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
