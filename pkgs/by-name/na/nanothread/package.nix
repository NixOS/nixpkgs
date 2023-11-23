{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
}:

stdenv.mkDerivation rec {
  pname = "nanothread";
  version = "unstable-2023-02-04";

  src = fetchFromGitHub {
    owner = "mitsuba-renderer";
    repo = "nanothread";

    # An old revision that still uses pybind11 instead of nanobind because some
    # of the other dependencies are lagging behind
    rev = "01c6ff7e4419b856602e590411860dc7206f8fb6";
    hash = "sha256-05y0/k0j8qS1yoVrJ+nkGR30N8MJ5283adABU5pz82I=";
    fetchSubmodules = true;
  };

  patches = [
    ./0001-CMakeLists.txt-add-install-targets.patch
    ./0002-cmake-installable-and-relocatable-include.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    stdenv.cc.cc.lib # libatomic
  ];

  meta = with lib; {
    description = "Nanothread — Minimal thread pool for task parallelism";
    homepage = "https://github.com/mitsuba-renderer/nanothread";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    mainProgram = "nanothread";
    platforms = platforms.all;
  };
}
