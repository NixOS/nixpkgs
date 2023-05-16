{ stdenv, lib, fetchFromGitHub
, cmake, libedit, gmpxx, bison, flex
, enableReadline ? false, readline
, gtest
}:

stdenv.mkDerivation rec {
  pname = "opensmt";
<<<<<<< HEAD
  version = "2.5.2";
=======
  version = "2.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "usi-verification-and-security";
    repo = "opensmt";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-gP2oaTEBVk54oK4Le5VudF7+HM8JXCzVqv8UXc08RFQ=";
=======
    sha256 = "sha256-+u0Go+QU56mmV1G+m+sDOhi3QaWveZILS9fWv8THoWc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake bison flex ];
  buildInputs = [ libedit gmpxx ]
    ++ lib.optional enableReadline readline;

  preConfigure = ''
    substituteInPlace test/CMakeLists.txt \
      --replace 'FetchContent_Populate' '#FetchContent_Populate'
  '';
  cmakeFlags = [
    "-Dgoogletest_SOURCE_DIR=${gtest.src}"
    "-Dgoogletest_BINARY_DIR=./gtest-build"
  ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "A satisfiability modulo theory (SMT) solver";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = if enableReadline then licenses.gpl2Plus else licenses.mit;
    homepage = "https://github.com/usi-verification-and-security/opensmt";
  };
}
