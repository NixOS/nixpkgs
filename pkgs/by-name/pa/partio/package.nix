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
  xorg,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "partio";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "wdas";
    repo = "partio";
    tag = "v${version}";
    hash = "sha256-p3mpxP0slHIQ75UtNAr5PcSOaSt9UyGR/MyOZ2GoXdU=";
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
    xorg.libXi
    xorg.libXmu
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libglut
    libGLU
    libGL
  ];

  # TODO:
  # Sexpr support

  strictDeps = true;

  meta = with lib; {
    description = "C++ (with python bindings) library for easily reading/writing/manipulating common animation particle formats such as PDB, BGEO, PTC";
    homepage = "https://github.com/wdas/partio";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.guibou ];
  };
}
