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
  ctestCheckHook,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eztrace";
  version = "2.1.1";

  outputs = [
    "out"
    "dev"
    "lib"
    "man"
  ];

  src = fetchFromGitLab {
    owner = "eztrace";
    repo = "eztrace";
    tag = "${finalAttrs.version}";
    hash = "sha256-ccW4YjEf++tkdIJLze2x8B/SWbBBXnYt8UV9OH8+KGU=";
  };

  # Possibly upstream these patches.
  patches = [
    ./0001-otf2-backend-cross.patch # To fix cross.
    ./0002-absolute-cmake-install-paths.patch # To fix generated .pc file
  ];

  postPatch = ''
    substituteInPlace src/eztrace-lib/eztrace_otf2.c \
      --replace-fail "/bin/rm" "rm"
    substituteInPlace cmake_modules/FindOTF2.cmake \
      --replace-fail "find_program(OTF2_CONFIG otf2-config REQUIRED)" \
                     "find_program(OTF2_CONFIG "${lib.getExe' otf2 "otf2-config"}" REQUIRED)" \
      --replace-fail "find_program(OTF2_PRINT otf2-print REQUIRED)" \
                     "find_program(OTF2_PRINT "${lib.getExe' otf2 "otf2-print"}" REQUIRED)"
    # 2.1.1 incorrectly reports 2.1.0. TODO: Remove after next release
    substituteInPlace CMakeLists.txt \
      --replace-fail "2.1.0" "${finalAttrs.version}"
    patchShebangs test
  '';

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "EZTRACE_ENABLE_MEMORY" true)
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
  disabledTests = [
    # This test is somewhat flaky and fails once per several rebuilds.
    "memory_tests"
  ];
  nativeCheckInputs = [
    otf2 # `otf2-print` needed by compiler_instrumentation_tests,pthread_tests,posixio_tests
    ctestCheckHook
  ];

  postInstall = ''
    moveToOutput bin/eztrace_create_plugin "$dev"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Tool that aims at generating automatically execution trace from HPC programs";
    homepage = "https://eztrace.gitlab.io/eztrace/index.html";
    downloadPage = "https://gitlab.com/eztrace/eztrace/";
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
