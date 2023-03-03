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
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "madMAx43v3r";
    repo = "chia-plotter";
    rev = "9d7fd929919d1adde6404cb4718a665a81bcef6d";
    sha256 = "sha256-TMAly+Qof2DHPRHqE1nZuHQaCeMo0jEd8MWy4OlXrcs=";
    fetchSubmodules = true;
  };

  patches = [
    # prevent CMake from trying to get libraries on the Internet
    (substituteAll {
      src = ./dont_fetch_dependencies.patch;
      pybind11_src = python3Packages.pybind11.src;
      relic_src = fetchFromGitHub {
        owner = "Chia-Network";
        repo = "relic";
        rev = "1d98e5abf3ca5b14fd729bd5bcced88ea70ecfd7";
        hash = "sha256-IfTD8DvTEXeLUoKe4Ejafb+PEJW5DV/VXRYuutwGQHU=";
      };
      sodium_src = fetchFromGitHub {
        owner = "AmineKhaldi";
        repo = "libsodium-cmake";
        rev = "f73a3fe1afdc4e37ac5fe0ddd401bf521f6bba65"; # pinned by upstream
        sha256 = "sha256-lGz7o6DQVAuEc7yTp8bYS2kwjzHwGaNjugDi1ruRJOA=";
        fetchSubmodules = true;
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
