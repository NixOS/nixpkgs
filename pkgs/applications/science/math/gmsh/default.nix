{
  lib,
  stdenv,
  fetchurl,
  cmake,
  blas,
  lapack,
  gfortran,
  gmm,
  fltk,
  libjpeg,
  zlib,
  libGL,
  libGLU,
  xorg,
  opencascade-occt,
  python ? null,
  enablePython ? false,
}:

assert (!blas.isILP64) && (!lapack.isILP64);
assert enablePython -> (python != null);

stdenv.mkDerivation rec {
  pname = "gmsh";
  version = "4.12.2";

  src = fetchurl {
    url = "https://gmsh.info/src/gmsh-${version}-source.tgz";
    hash = "sha256-E+CdnKgQLlxAFx1u4VDGaHQrmMOmylf4N/e2Th4q9I8=";
  };

  buildInputs =
    [
      blas
      lapack
      gmm
      fltk
      libjpeg
      zlib
      opencascade-occt
    ]
    ++ lib.optionals (!stdenv.isDarwin) [
      libGL
      libGLU
      xorg.libXrender
      xorg.libXcursor
      xorg.libXfixes
      xorg.libXext
      xorg.libXft
      xorg.libXinerama
      xorg.libX11
      xorg.libSM
      xorg.libICE
    ]
    ++ lib.optional enablePython python;

  enableParallelBuilding = true;

  patches = [
    ./fix-python.patch
  ];

  postPatch = ''
    substituteInPlace api/gmsh.py --subst-var-by LIBPATH ${placeholder "out"}/lib/libgmsh.so
  '';

  # N.B. the shared object is used by bindings
  cmakeFlags = [
    "-DENABLE_BUILD_SHARED=ON"
    "-DENABLE_BUILD_DYNAMIC=ON"
    "-DENABLE_OPENMP=ON"
  ];

  nativeBuildInputs = [
    cmake
    gfortran
  ];

  postFixup = lib.optionalString enablePython ''
    mkdir -p $out/lib/python${python.pythonVersion}/site-packages
    mv $out/lib/gmsh.py $out/lib/python${python.pythonVersion}/site-packages
    mv $out/lib/*.dist-info $out/lib/python${python.pythonVersion}/site-packages
  '';

  doCheck = true;

  meta = {
    description = "A three-dimensional finite element mesh generator";
    mainProgram = "gmsh";
    homepage = "https://gmsh.info/";
    license = lib.licenses.gpl2Plus;
  };
}
