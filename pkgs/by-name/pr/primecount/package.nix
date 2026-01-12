{
  lib,
  cmake,
  fetchFromGitHub,
  gitUpdater,
  primesieve,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "primecount";
  version = "7.20";

  src = fetchFromGitHub {
    owner = "kimwalisch";
    repo = "primecount";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rM+c1CDD75bRqvUMI8Ej02nSqkweR8+E4Wpag7mJcM4=";
  };

  outputs = [
    "out"
    "dev"
    "lib"
    "man"
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ primesieve ];

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_LIBPRIMESIEVE" true)
    (lib.cmakeBool "BUILD_PRIMECOUNT" true)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "BUILD_STATIC_LIBS" stdenv.hostPlatform.isStatic)
    (lib.cmakeBool "BUILD_TESTS" true)
  ];

  passthru = {
    tests = {
      inherit primesieve; # dependency
    };
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

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
    inherit (primesieve.meta) teams platforms;
  };
})
