{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  libedit,
  gmpxx,
  bison,
  flex,
  enableReadline ? false,
  readline,
  gtest,
}:

stdenv.mkDerivation rec {
  pname = "opensmt";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "usi-verification-and-security";
    repo = "opensmt";
    rev = "v${version}";
    sha256 = "sha256-zhNNnwc41B4sNq50kPub29EYhqV+FoDKRD/CLHnVyZw=";
  };

  nativeBuildInputs = [
    cmake
    bison
    flex
  ];
  buildInputs = [
    libedit
    gmpxx
  ] ++ lib.optional enableReadline readline;

  preConfigure = ''
    substituteInPlace test/CMakeLists.txt \
      --replace 'FetchContent_Populate' '#FetchContent_Populate'
  '';
  cmakeFlags = [
    "-Dgoogletest_SOURCE_DIR=${gtest.src}"
    "-Dgoogletest_BINARY_DIR=./gtest-build"
  ];

  meta = {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    description = "Satisfiability modulo theory (SMT) solver";
    mainProgram = "opensmt";
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    license = if enableReadline then lib.licenses.gpl2Plus else lib.licenses.mit;
    homepage = "https://github.com/usi-verification-and-security/opensmt";
  };
}
