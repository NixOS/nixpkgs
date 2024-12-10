{
  lib,
  cmake,
  fetchFromGitHub,
  primesieve,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "primecount";
  version = "7.13";

  src = fetchFromGitHub {
    owner = "kimwalisch";
    repo = "primecount";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VjsJjG2pSnDMVg3lY3cmpdnASeqClPjHUGY5wqupf2w=";
  };

  outputs = [
    "out"
    "dev"
    "lib"
    "man"
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    primesieve
  ];

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_LIBPRIMESIEVE" true)
    (lib.cmakeBool "BUILD_PRIMECOUNT" true)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "BUILD_STATIC_LIBS" stdenv.hostPlatform.isStatic)
    (lib.cmakeBool "BUILD_TESTS" true)
  ];

  meta = {
    homepage = "https://github.com/kimwalisch/primecount";
    description = "Fast prime counting function implementations";
    longDescription = ''
      primecount is a command-line program and C/C++ library that counts the
      primes below an integer x ≤ 10^31 using highly optimized implementations
      of the combinatorial prime counting algorithms.

      primecount includes implementations of all important combinatorial prime
      counting algorithms known up to this date all of which have been
      parallelized using OpenMP. primecount contains the first ever open source
      implementations of the Deleglise-Rivat algorithm and Xavier Gourdon's
      algorithm (that works). primecount also features a novel load balancer
      that is shared amongst all implementations and that scales up to hundreds
      of CPU cores. primecount has already been used to compute several prime
      counting function world records.
    '';
    changelog = "https://github.com/kimwalisch/primecount/blob/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.bsd2;
    mainProgram = "primecount";
    inherit (primesieve.meta) maintainers platforms;
  };
})
