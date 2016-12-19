{ stdenv, fetchurl, qt4, bzip2, lib3ds, levmar, muparser, unzip, vcg }:

stdenv.mkDerivation rec {
  name = "meshlab-1.3.3";

  src = fetchurl {
    url = "mirror://sourceforge/meshlab/meshlab/MeshLab%20v1.3.3/MeshLabSrc_AllInc_v133.tgz";
    sha256 = "03wqaibfbfag2w1zi1a5z6h546r9d7pg2sjl5pwg24w7yp8rr0n9";
  };

  # I don't know why I need this; without this, the rpath set at the beginning of the
  # buildPhase gets removed from the 'meshlab' binary
  dontPatchELF = true;

  patches = [ ./include-unistd.diff ];

  hardeningDisable = [ "format" ];

  buildPhase = ''
    mkdir -p "$out/include"
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

  buildInputs = [ qt4 unzip vcg ];

  meta = {
    description = "System for the processing and editing of unstructured 3D triangular meshes";
    homepage = http://meshlab.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
    broken = stdenv.isLinux && stdenv.isi686;
  };
}
