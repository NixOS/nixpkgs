{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
  boost,
  robin-map,
  catch2_3,
  fmt,
  xbyak,
  zydis,
  nix-update-script,
  azahar,
  darwin,
}:
let
  oaknut = stdenv.mkDerivation {
    pname = "oaknut";
    version = "1.2.2-unstable-2024-03-01";

    src = fetchFromGitHub {
      owner = "merryhime";
      repo = "oaknut";
      rev = "94c726ce0338b054eb8cb5ea91de8fe6c19f4392";
      hash = "sha256-IhP/110NGN42/FvpGIEm9MgsSiPYdtD8kNxL0cAWbqM=";
    };

    nativeBuildInputs = [
      cmake
      ninja
    ];
  };

  mcl = stdenv.mkDerivation {
    pname = "mcl";
    version = "0.1.13-unstable-2025-03-16";

    src = fetchFromGitHub {
      owner = "azahar-emu";
      repo = "mcl";
      rev = "7b08d83418f628b800dfac1c9a16c3f59036fbad";
      hash = "sha256-uTOiOlMzKbZSjKjtVSqFU+9m8v8horoCq3wL0O2E8sI=";
    };

    nativeBuildInputs = [
      cmake
      ninja
    ];

    buildInputs = [
      fmt
    ];

    checkInputs = [
      catch2_3
    ];

    doCheck = true;
    checkPhase = ''
      tests/mcl-tests
    '';
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dynarmic";
  version = "6.7.0-unstable-2025-03-16";

  src = fetchFromGitHub {
    owner = "azahar-emu";
    repo = "dynarmic";
    rev = "278405bd71999ed3f3c77c5f78344a06fef798b9";
    hash = "sha256-D7nXn5y0h8FV0V8Tc8uBlRoeEU+gcpt44afujZvG+1A=";
  };

  patches = [
    # https://github.com/azahar-emu/dynarmic/pull/2
    ./0001-CMakeLists-update-mcl-version-to-0.1.13.patch
    # https://github.com/azahar-emu/dynarmic/pull/3
    ./0001-xbyak-Fix-tests-when-using-newer-versions.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.DarwinTools # sw_ver
    darwin.bootstrap_cmds # mig
  ];

  buildInputs = [
    boost
    robin-map
    mcl
    fmt
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [
    oaknut
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    xbyak
    zydis
  ];

  checkInputs = [
    catch2_3
    oaknut
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "DYNARMIC_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  env = lib.optionalAttrs stdenv.cc.isGNU {
    # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=117063
    NIX_CFLAGS_COMPILE = "-Wno-error=stringop-overread";
  };

  doCheck = true;

  passthru = {
    inherit mcl oaknut;

    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
    tests = { inherit azahar; };
  };

  meta = {
    description = "Dynamic recompiler for ARM";
    homepage = "https://github.com/azahar-emu/dynarmic";
    maintainers = with lib.maintainers; [ marcin-serwin ];
    license = lib.licenses.bsd0;
    platforms = with lib.platforms; x86_64 ++ aarch64;
  };
})
