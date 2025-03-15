{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  gfortran,
  pkg-config,
  libelf,
  libiberty,
  libbfd,
  libopcodes,
  libotf2,
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
    ./0001-otf2.patch
  ];

  postPatch = ''
    substituteInPlace src/eztrace-lib/eztrace_otf2.c \
      --replace-fail "/bin/rm" "rm"
    substituteInPlace cmake_modules/FindOTF2.cmake \
      --replace-fail otf2-config "${lib.getExe' libotf2 "otf2-config"}"
    patchShebangs test
  '';

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "EZTRACE_ENABLE_MEMORY" true)
    # This test is somewhat flaky and fails once per several rebuilds.
    # TODO: Switch to disabledTests if https://www.github.com/NixOS/nixpkgs/pull/379426
    # is accepted.
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" "--exclude-regex;memory_tests")
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    libotf2
    gfortran
  ];

  buildInputs = [
    libelf
    libiberty
    libbfd
    libopcodes
    libotf2
  ];

  doCheck = true;

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
