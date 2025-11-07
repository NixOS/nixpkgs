{
  lib,
  stdenv,
  requireFile,
  cmake,
  libGLU,
  libGL,
  libX11,
  libXi,
}:

stdenv.mkDerivation rec {
  pname = "liquidfun";
  version = "1.1.0";

  src = requireFile {
    url = "https://github.com/google/liquidfun/releases/download/v${version}/liquidfun-${version}";
    sha256 = "5011a000eacd6202a47317c489e44aa753a833fb562d970e7b8c0da9de01df86";
    name = "liquidfun-${version}.tar.gz";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libGLU
    libGL
    libX11
    libXi
  ];

  sourceRoot = "liquidfun/Box2D";

  preConfigurePhases = [ "preConfigure" ];

  preConfigure = ''
    sed -i Box2D/Common/b2Settings.h -e 's@b2_maxPolygonVertices .*@b2_maxPolygonVertices 15@'
    substituteInPlace Box2D/CMakeLists.txt --replace "Common/b2GrowableStack.h" "Common/b2GrowableStack.h Common/b2GrowableBuffer.h"
  '';

  configurePhase = ''
    runHook preConfigure

    mkdir Build
    cd Build;
    cmake -DBOX2D_INSTALL=ON -DBOX2D_BUILD_SHARED=ON -DCMAKE_INSTALL_PREFIX=$out ..

    runHook postConfigure
  '';

  meta = with lib; {
    description = "2D physics engine based on Box2D";
    maintainers = with maintainers; [ qknight ];
    platforms = platforms.linux;
    hydraPlatforms = [ ];
    license = licenses.bsd2;
    homepage = "https://google.github.io/liquidfun/";
  };
}
