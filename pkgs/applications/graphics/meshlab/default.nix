{ mkDerivation, lib, fetchFromGitHub
, fetchpatch
, libGLU
, qtbase
, qtscript
, qtxmlpatterns
, lib3ds
, bzip2
, muparser
, eigen
, glew
, gmp
, levmar
, qhull
, cmake
}:

mkDerivation rec {
  pname = "meshlab";
  version = "2020.03";

  src = fetchFromGitHub {
    owner = "cnr-isti-vclab";
    repo = "meshlab";
    rev = "f3568e75c9aed6da8bb105a1c8ac7ebbe00e4536";
    sha256 = "17g9icgy1w67afxiljzxk94dyhj4f336gjxn0bhppd58xfqh8w4g";
    fetchSubmodules = true; # for vcglib
  };

  buildInputs = [
    libGLU
    qtbase
    qtscript
    qtxmlpatterns
    lib3ds
    bzip2
    muparser
    eigen
    glew
    gmp
    levmar
    qhull
  ];

  nativeBuildInputs = [ cmake ];

  patches = [ ./no-build-date.patch ];

  # MeshLab computes the version based on the build date, remove when https://github.com/cnr-isti-vclab/meshlab/issues/622 is fixed.
  postPatch = ''
    substituteAll ${./fix-version.patch} /dev/stdout | patch -p1 --binary
  '';

  preConfigure = ''
    substituteAll ${./meshlab.desktop} install/linux/resources/meshlab.desktop
    cd src
  '';

  cmakeFlags = [
    "-DALLOW_BUNDLED_EIGEN=OFF"
    "-DALLOW_BUNDLED_GLEW=OFF"
    "-DALLOW_BUNDLED_LIB3DS=OFF"
    "-DALLOW_BUNDLED_MUPARSER=OFF"
    "-DALLOW_BUNDLED_QHULL=OFF"
     # disable when available in nixpkgs
    "-DALLOW_BUNDLED_OPENCTM=ON"
    "-DALLOW_BUNDLED_SSYNTH=ON"
    # some plugins are disabled unless these are on
    "-DALLOW_BUNDLED_NEWUOA=ON"
    "-DALLOW_BUNDLED_LEVMAR=ON"
  ];

  # Meshlab is not format-security clean; without disabling hardening, we get:
  # src/common/GLLogStream.h:61:37: error: format not a string literal and no format arguments [-Werror=format-security]
  #  61 |         int chars_written = snprintf(buf, buf_size, f, std::forward<Ts>(ts)...);
  #     |
  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  meta = {
    description = "A system for processing and editing 3D triangular meshes.";
    homepage = "http://www.meshlab.net/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [viric];
    platforms = with lib.platforms; linux;
  };
}
