{ lib
, fetchFromGitHub
, stdenv
, libsodium
, cmake
, substituteAll
, python3Packages
}:

stdenv.mkDerivation {
  pname = "chia-plotter";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "madMAx43v3r";
    repo = "chia-plotter";
    rev = "18cad340858f0dbcc8dafd0bda1ce1af0fe58c65";
    sha256 = "sha256-lXjeqcjn3+LtnVYngdM1T3on7V7wez4oOAZ0RpKJXMM=";
    fetchSubmodules = true;
  };

  patches = [
    # prevent CMake from trying to get libraries on the Internet
    (substituteAll {
      src = ./dont_fetch_dependencies.patch;
      pybind11_src = python3Packages.pybind11.src;
      relic_src = fetchFromGitHub {
        owner = "relic-toolkit";
        repo = "relic";
        rev = "1885ae3b681c423c72b65ce1fe70910142cf941c";
        hash = "sha256-tsSZTcssl8t7Nqdex4BesgQ+ACPgTdtHnJFvS9josN0=";
      };
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libsodium ];

  # These flags come from the upstream build script:
  # https://github.com/madMAx43v3r/chia-plotter/blob/974d6e5f1440f68c48492122ca33828a98864dfc/make_devel.sh#L7
  CXXFLAGS = "-O3 -fmax-errors=1";
  cmakeFlags = [
    "-DARITH=easy"
    "-DBUILD_BLS_PYTHON_BINDINGS=false"
    "-DBUILD_BLS_TESTS=false"
    "-DBUILD_BLS_BENCHMARKS=false"
  ];

  installPhase = ''
    runHook preInstall

    install -D -m 755 chia_plot $out/bin/chia_plot

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/madMAx43v3r/chia-plotter";
    description = "New implementation of a chia plotter which is designed as a processing pipeline";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ilyakooo0 ];
  };
}
