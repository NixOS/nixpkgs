{stdenv, fetchurl, qt, bzip2, lib3ds, levmar, muparser, unzip}:

stdenv.mkDerivation rec {
  name = "meshlab-1.2.3a";

  src = fetchurl {
    url = mirror://sourceforge/meshlab/MeshLabSrc_AllInc_v123a.tgz;
    sha256 = "09w42q0x1yjr7l9ng952lic7vkb1arsvqg1fld5s297zwzfmsl9v";
  };

  # I don't know why I need this; without this, the rpath set at the beginning of the
  # buildPhase gets removed from the 'meshlab' binary
  dontPatchELF = true;

  buildPhase = ''
    export NIX_LDFLAGS="-rpath $out/opt/meshlab $NIX_LDFLAGS"
    cd meshlab/src
    pushd external
    qmake -recursive external.pro
    make
    popd
    qmake -recursive meshlabv12.pro
    make
  '';

  installPhase = ''
    ensureDir $out/opt/meshlab $out/bin $out/lib
    pushd distrib
    cp -R * $out/opt/meshlab
    popd
    ln -s $out/opt/meshlab/meshlab $out/bin/meshlab
  '';

  buildInputs = [ qt unzip ];

  meta = {
    description = "System for the processing and editing of unstructured 3D triangular meshes";
    homepage = http://meshlab.sourceforge.net/;
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
