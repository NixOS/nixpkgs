{
  runCommandCC,
  lfortran,
  fortran-fpm,
}:

# Compile the Fortran Package Manager (a single ~53k line source file) with
# LFortran, then use that fpm to build, run and test a fresh project with
# LFortran as its compiler. fpm runs `ar` itself, hence runCommandCC.
runCommandCC "${lfortran.pname}-test-fpm"
  {
    nativeBuildInputs = [ lfortran ];
  }
  ''
    # The same flags upstream uses for fpm in ci/test_third_party_codes.sh.
    lfortran --cpp --realloc-lhs-arrays --use-loop-variable-after-loop \
      ${fortran-fpm.src} -o fpm 2>/dev/null
    ./fpm --version | grep -F "Version:     ${fortran-fpm.version}"

    # fpm falls back to /etc/os-release, absent in the sandbox, when OSTYPE is
    # unset; with an unknown OS it archives with the MSVC `lib` tool.
    export OSTYPE HOME=$TMPDIR

    ./fpm new proj
    cd proj
    ../fpm run --compiler lfortran | tee /dev/stderr | grep -F "Hello, proj!"
    ../fpm test --compiler lfortran | tee /dev/stderr | grep -F "Put some tests in here!"
    touch $out
  ''
