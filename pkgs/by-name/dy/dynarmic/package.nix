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
  oaknut,
  mcl-cpp-utility-lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dynarmic";
  version = "6.7.0-unstable-2026-01-04";

  src = fetchFromGitHub {
    owner = "azahar-emu";
    repo = "dynarmic";
    rev = "526227eebe1efff3fb14dbf494b9c5b44c2e9c1f";
    hash = "sha256-WG9mUFUnhEEF0+qsQzslTAj1nox3jaz6rVKs245EtV4=";
  };

  patches = [
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
    mcl-cpp-utility-lib
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
