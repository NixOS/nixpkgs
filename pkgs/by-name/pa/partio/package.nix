{
  lib,
  stdenv,
  fetchFromGitHub,
  unzip,
  cmake,
  libglut,
  libGLU,
  libGL,
  zlib,
  swig,
  doxygen,
  libxmu,
  libxi,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "partio";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "wdas";
    repo = "partio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uzMp3jj0HUB6vOjc/uvvT4Bmi6xp0qz4OYPG+bmlgaM=";
  };

  outputs = [
    "dev"
    "out"
    "lib"
  ];

  nativeBuildInputs = [
    unzip
    cmake
    doxygen
    python3
  ];

  buildInputs = [
    zlib
    swig
    libxi
    libxmu
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libglut
    libGLU
    libGL
  ];

  # TODO:
  # Sexpr support

  strictDeps = true;

  meta = {
    description = "C++ (with python bindings) library for easily reading/writing/manipulating common animation particle formats such as PDB, BGEO, PTC";
    homepage = "https://github.com/wdas/partio";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.guibou ];
  };
})
