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
  version = "2.9.2";

  src = fetchFromGitHub {
    owner = "usi-verification-and-security";
    repo = "opensmt";
    rev = "v${version}";
    sha256 = "sha256-xKpYABMn2bsXRg2PMjiMhsx6+FbAsxitLRnmqa1kmu0=";
  };

  nativeBuildInputs = [
    cmake
    bison
    flex
  ];
  buildInputs = [
    libedit
    gmpxx
    gtest
  ]
  ++ lib.optional enableReadline readline;

  preConfigure = ''
    substituteInPlace test/CMakeLists.txt \
      --replace-fail 'FetchContent_MakeAvailable' '#FetchContent_MakeAvailable'
  '';

  meta = with lib; {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    description = "Satisfiability modulo theory (SMT) solver";
    mainProgram = "opensmt";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = if enableReadline then licenses.gpl2Plus else licenses.mit;
    homepage = "https://github.com/usi-verification-and-security/opensmt";
  };
}
