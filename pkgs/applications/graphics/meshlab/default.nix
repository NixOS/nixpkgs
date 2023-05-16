{ mkDerivation
, lib
, fetchFromGitHub
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
, cgal_5
<<<<<<< HEAD
, boost179
=======
, boost17x
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, mpfr
, xercesc
}:

mkDerivation rec {
  pname = "meshlab";
  version = "2022.02";

  src = fetchFromGitHub {
    owner = "cnr-isti-vclab";
    repo = "meshlab";
<<<<<<< HEAD
    rev = "MeshLab-${version}";
    sha256 = "sha256-jcc3PfsiIeYyipteZgzd0NwZgFFgR/mMBiaInzhOcDY=";
=======
    rev = "Meshlab-${version}";
    sha256 = "sha256-MP+jkiV6yS1T1eWClxM56kZWLXwu0g4w/zBHy6CSL6Y=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    cgal_5
<<<<<<< HEAD
    boost179
=======
    boost17x
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    mpfr
    xercesc
  ];

  nativeBuildInputs = [ cmake ];

  preConfigure = ''
    substituteAll ${./meshlab.desktop} scripts/Linux/resources/meshlab.desktop
    cmakeDir=$PWD/src
    mkdir ../build
    cd ../build
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
    "-DALLOW_BUNDLED_BOOST=OFF"
    # some plugins are disabled unless these are on
    "-DALLOW_BUNDLED_NEWUOA=ON"
    "-DALLOW_BUNDLED_LEVMAR=ON"
  ];

  postFixup = ''
    patchelf --add-needed $out/lib/meshlab/libmeshlab-common.so $out/bin/.meshlab-wrapped
  '';

  meta = {
    description = "A system for processing and editing 3D triangular meshes";
    homepage = "https://www.meshlab.net/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ viric ];
    platforms = with lib.platforms; linux;
  };
}
