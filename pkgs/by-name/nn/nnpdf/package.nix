{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  apfel,
  gsl,
  lhapdf,
  libarchive,
  yaml-cpp,
  python3,
  sqlite,
  swig,
}:

stdenv.mkDerivation rec {
  pname = "nnpdf";
  version = "4.0.9";

  src = fetchFromGitHub {
    owner = "NNPDF";
    repo = "nnpdf";
    rev = version;
    hash = "sha256-PyhkHlOlzKfDxUX91NkeZWjdEzFR4PW0Yh5Yz6ZA27g=";
  };

  postPatch = ''
    for file in CMakeLists.txt buildmaster/CMakeLists.txt; do
      substituteInPlace $file \
        --replace "-march=nocona -mtune=haswell" ""
    done

    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required (VERSION 3.0.2)" "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    apfel
    gsl
    lhapdf
    libarchive
    yaml-cpp
    python3
    python3.pkgs.numpy
    sqlite
    swig
  ];

  cmakeFlags = [
    "-DCOMPILE_filter=ON"
    "-DCOMPILE_evolvefit=ON"
  ];

  meta = with lib; {
    description = "Open-source machine learning framework for global analyses of parton distributions";
    mainProgram = "evolven3fit";
    homepage = "https://docs.nnpdf.science/";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.veprbl ];
    platforms = platforms.unix;
  };
}
