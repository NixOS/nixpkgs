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
  version = "372-unstable-2025-10-11";

  # To correlate scipVersion and version, check: https://scipopt.org/#news
  scipVersion = "9.2.4";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "gcg";
    rev = "83a2d210a03f920dd941d547da94867deb504882";
    hash = "sha256-wbzknCmwDhJ38gItA3DppJxSJfNK7NeIkxZVRd2kmp0=";
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

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.3)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    maintainers = with lib.maintainers; [ fettgoenner ];
    changelog = "https://scipopt.org/doc-${scipVersion}/html/RN${lib.versions.major scipVersion}.php";
    description = "Branch-and-Price & Column Generation for Everyone";
    license = lib.licenses.lgpl3Plus;
    homepage = "https://gcg.zib.de";
    mainProgram = "gcg";
  };
}
