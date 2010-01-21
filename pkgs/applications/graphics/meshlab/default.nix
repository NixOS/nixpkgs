{stdenv, fetchurl, qt, bzip2}:

stdenv.mkDerivation {
  name = "meshlab-1.2.2";

  src = fetchurl {
    url = mirror://sourceforge/meshlab/MeshLabSrc_v122.tar.gz;
    sha256 = "166a8mx72wf3r84pnpr0ssqkd2xw6y5brviywlj8rjk6w9cy8fdc";
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
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
