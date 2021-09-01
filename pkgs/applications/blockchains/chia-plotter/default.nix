{ lib
, fetchFromGitHub
, stdenv
, libsodium
, cmake
, substituteAll
, pythonPackages
}:

stdenv.mkDerivation {
  pname = "chia-plotter";
  version = "unstable-2021-07-12";

  src = fetchFromGitHub {
    owner = "madMAx43v3r";
    repo = "chia-plotter";
    rev = "974d6e5f1440f68c48492122ca33828a98864dfc";
    sha256 = "0dliswvqmi3wq9w8jp0sb0z74n5k37608sig6r60z206g2bwhjja";
    fetchSubmodules = true;
  };

  patches = [
    # prevent CMake from trying to get libraries on the Internet
    (substituteAll {
      src = ./dont_fetch_dependencies.patch;
      pybind11_src = pythonPackages.pybind11.src;
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
