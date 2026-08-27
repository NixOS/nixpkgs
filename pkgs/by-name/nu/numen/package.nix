{
  lib,
  stdenv,
  fetchFromGitHub,
  catch2_3,
  cmake,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "numen";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "vicinaehq";
    repo = "numen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j+Y331tYcnCTnQ9NdqqwDME6PLQU/1Xtid/8CKfdSC4=";
  };

  __structuredAttrs = true;

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "BUILD_REPL" false)
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.doCheck)
    (lib.cmakeBool "USE_SYSTEM_CATCH" true)
  ];

  # needs /etc/localtime
  doCheck = !stdenv.hostPlatform.isDarwin;
  checkInputs = [ catch2_3 ];

  meta = {
    description = "Natural language calculator library";
    homepage = "https://github.com/vicinaehq/numen";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nolight132 ];
    platforms = lib.platforms.unix;
  };
})
