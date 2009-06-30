{stdenv, fetchurl, qt, bzip2}:

stdenv.mkDerivation {
  name = "meshlab-1.2.0";

  src = fetchurl {
    url = mirror://sourceforge/meshlab/MeshLabSrc_v120.tgz;
    sha256 = "0iidp2pzwq96v8zbm8gc67wi1f41anpkncp17ajkv1rrh653nila";
  };


  setSourceRoot = "sourceRoot=`pwd`/meshlab/src";

  buildPhase = ''
    pushd external
    qmake -recursive external.pro
    make
    popd
    qmake -recursive meshlabv12.pro
    make
  '';

  installPhase = ''
    ensureDir $out/opt/meshlab $out/bin
    pushd meshlab
    cp -R meshlab plugins shaders* textures images $out/opt/meshlab
    popd
    ln -s $out/opt/meshlab/meshlab $out/bin/meshlab
  '';

  buildInputs = [ qt bzip2 ];

  meta = {
    description = "System for the processing and editing of unstructured 3D triangular meshes";
    homepage = http://meshlab.sourceforge.net/;
    license = "GPLv2+";
  };
}
