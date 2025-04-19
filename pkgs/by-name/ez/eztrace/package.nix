{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  gfortran,
  libelf,
  libiberty,
  libbfd,
  libopcodes,
  otf2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eztrace";
  version = "2.1.1";

  outputs = [
    "out"
    "lib"
    "man"
  ];

  src = fetchFromGitLab {
    owner = "eztrace";
    repo = "eztrace";
    tag = "${finalAttrs.version}";
    hash = "sha256-ccW4YjEf++tkdIJLze2x8B/SWbBBXnYt8UV9OH8+KGU=";
  };

  patches = [
    ./0001-otf2-backend-cross.patch # To fix cross.
  ];

  postPatch = ''
    substituteInPlace src/eztrace-lib/eztrace_otf2.c \
      --replace-fail "/bin/rm" "rm"
    substituteInPlace cmake_modules/FindOTF2.cmake \
      --replace-fail "find_program(OTF2_CONFIG otf2-config REQUIRED)" \
                     "find_program(OTF2_CONFIG "${lib.getExe' otf2 "otf2-config"}" REQUIRED)" \
      --replace-fail "find_program(OTF2_PRINT otf2-print REQUIRED)" \
                     "find_program(OTF2_PRINT "${lib.getExe' otf2 "otf2-print"}" REQUIRED)"
    patchShebangs test
  '';

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "EZTRACE_ENABLE_MEMORY" true)
    # This test is somewhat flaky and fails once per several rebuilds.
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" "--exclude-regex;memory_tests")
  ];

  nativeBuildInputs = [
    cmake
    gfortran
  ];

  buildInputs = [
    libelf
    libiberty
    libbfd
    libopcodes
    otf2
  ];

  doCheck = true;
  nativeCheckInputs = [
    otf2 # `otf2-print` needed by compiler_instrumentation_tests,pthread_tests,posixio_tests
  ];

  meta = {
    description = "Tool that aims at generating automatically execution trace from HPC programs";
    license = lib.licenses.cecill-b;
    maintainers = [ lib.maintainers.xokdvium ];
    mainProgram = "eztrace";
    badPlatforms = [
      # Undefined symbols for architecture x86_64:
      #        >   "___cyg_profile_func_enter", referenced from:
      lib.systems.inspect.patterns.isDarwin
    ];
  };
})
