{stdenv, fetchurl, qt, bzip2, lib3ds, levmar, muparser, unzip}:

stdenv.mkDerivation rec {
  name = "meshlab-1.2.2";

  src = fetchurl {
    url = mirror://sourceforge/meshlab/MeshLabSrc_v122.tar.gz;
    sha256 = "166a8mx72wf3r84pnpr0ssqkd2xw6y5brviywlj8rjk6w9cy8fdc";
  };

  srcGlew151 = fetchurl {
    url = http://dfn.dl.sourceforge.net/sourceforge/glew/glew-1.5.1-src.tgz;
    sha256 = "02n1p6s6sia92fgng9iq0kqq890rga8d8g0y34mc6qxmbh43vrl9";
  };

  srcQHull20031 = fetchurl {
    url = http://www.qhull.org/download/qhull-2003.1.zip;
    sha256 = "07mh371i6xs691qz6wwzkqk9h0d2dkih2q818is2b041w1l79b46";
  };


  patchPhase = ''
    cd meshlab/src
    mkdir external
    pushd external
    tar xf ${srcGlew151}
    mv glew glew-1.5.1
    unzip ${srcQHull20031}
    popd
  '';

  buildPhase = ''
    pwd
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

  buildInputs = [ qt bzip2 lib3ds levmar muparser unzip ];

  meta = {
    description = "System for the processing and editing of unstructured 3D triangular meshes";
    homepage = http://meshlab.sourceforge.net/;
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
