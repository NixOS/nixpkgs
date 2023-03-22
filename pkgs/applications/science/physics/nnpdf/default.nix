{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, apfel
, gsl
, lhapdf
, libarchive
, yaml-cpp
, python3
, sqlite
, swig
}:

stdenv.mkDerivation rec {
  pname = "nnpdf";
  version = "4.0.6";

  src = fetchFromGitHub {
    owner = "NNPDF";
    repo = pname;
    rev = version;
    hash = "sha256-mwOMNlYFhHZq/wakO1/HGwcxvKGKh5OyFa2D9d3Y3IA=";
  };

  postPatch = ''
    for file in CMakeLists.txt buildmaster/CMakeLists.txt; do
      substituteInPlace $file \
        --replace "-march=nocona -mtune=haswell" ""
    done
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
    description = "An open-source machine learning framework for global analyses of parton distributions";
    homepage = "https://docs.nnpdf.science/";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.veprbl ];
    platforms = platforms.unix;
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = (stdenv.isDarwin && stdenv.isAarch64) || (stdenv.isLinux && stdenv.isAarch64);
  };
}
