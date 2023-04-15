{ lib
, stdenv
, fetchFromGitHub
, cmake
, primesieve
}:

stdenv.mkDerivation rec {
  pname = "primecount";
  version = "7.8";

  src = fetchFromGitHub {
    owner = "kimwalisch";
    repo = "primecount";
    rev = "v${version}";
    hash = "sha256-yKk+zXvA/MI7y9gCMwJNYHRYIYgeWyJHjyPi1uNWVnM=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    primesieve
  ];

  cmakeFlags = [
    "-DBUILD_LIBPRIMESIEVE=ON"
    "-DBUILD_PRIMECOUNT=ON"
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_STATIC_LIBS=OFF"
    "-DBUILD_TESTS=ON"
  ];

  meta = with lib; {
    homepage = "https://github.com/kimwalisch/primecount";
    changelog = "https://github.com/kimwalisch/primecount/blob/v${version}/ChangeLog";
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
    license = licenses.bsd2;
    inherit (primesieve.meta) maintainers platforms;
  };
}
