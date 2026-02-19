{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  scipopt-scip,
  cliquer,
  gsl,
  gmp,
  bliss,
  nauty,
}:

stdenv.mkDerivation rec {
  pname = "scipopt-gcg";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "gcg";
    tag = "v${version}";
    hash = "sha256-eu7JHtG10/4rzr4xSdoFJjGQ+X5OeWelkEWJOO7QQmE=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    scipopt-scip
    cliquer
    gsl
    gmp
    bliss
    nauty
  ];

  # Fixing the error
  #   > CMake Error at CMakeLists.txt:236 (find_package):
  #   >   By not providing "FindNAUTY.cmake" in CMAKE_MODULE_PATH this project has
  #   >   asked CMake to find a package configuration file provided by "NAUTY", but
  #   >   CMake did not find one.
  # with this weird workaround of setting SCIPOptSuite_SOURCE_DIR to include the scipopt-scip source
  # files via symlinks, so the specific nauty files are found:
  preConfigure = ''
    mkdir -pv $out/scip
    ln -sv ${scipopt-scip.src}/src/ $out/scip/src
    cmakeFlagsArray+=(
      "-DSCIPOptSuite_SOURCE_DIR=$out"
    )
  '';
  doCheck = true;

  meta = {
    maintainers = with lib.maintainers; [ fettgoenner ];
    changelog = "https://gcg.or.rwth-aachen.de/doc-3.5.0/RN${lib.versions.major version}${lib.versions.minor version}.html";
    description = "Branch-and-Price & Column Generation for Everyone";
    license = lib.licenses.lgpl3Plus;
    homepage = "https://gcg.zib.de";
    mainProgram = "gcg";
  };
}
