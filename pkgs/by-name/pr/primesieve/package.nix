{ lib
, cmake
, fetchFromGitHub
, stdenv
, primecount
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "primesieve";
  version = "12.1";

  src = fetchFromGitHub {
    owner = "kimwalisch";
    repo = "primesieve";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AHl2GfZ1oJ8ZyjJzvg10AqN7TA7HFZ+qa6N2v51Qa78=";
  };

  outputs = [ "out" "dev" "lib" "man" ];

  nativeBuildInputs = [ cmake ];

  strictDeps = true;

  passthru = {
    tests = {
      inherit primecount; # dependent
    };
  };

  meta = {
    homepage = "https://primesieve.org/";
    description = "Fast C/C++ prime number generator";
    longDescription = ''
      primesieve is a command-line program and C/C++ library for quickly
      generating prime numbers. It is very cache efficient, it detects your
      CPU's L1 & L2 cache sizes and allocates its main data structures
      accordingly. It is also multi-threaded by default, it uses all available
      CPU cores whenever possible i.e. if sequential ordering is not
      required. primesieve can generate primes and prime k-tuplets up to 264.
    '';
    changelog = "https://github.com/kimwalisch/primesieve/blob/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.bsd2;
    mainProgram = "primesieve";
    maintainers = lib.teams.sage.members ++
      (with lib.maintainers; [ abbradar AndersonTorres ]);
    platforms = lib.platforms.unix;
  };
})
