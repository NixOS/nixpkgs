{
  lib,
  stdenv,
  fetchFromGitHub,
  catch2_3,
  cmake,
  glibcLocales,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "numen";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "vicinaehq";
    repo = "numen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kjnCgTn45XzFmoiHZYFZsToyc+TXHQ43Nk0UkEbhw68=";
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
  nativeCheckInputs = lib.optionals stdenv.hostPlatform.isLinux [ glibcLocales ];

  # sandbox has no locale data
  env = lib.optionalAttrs stdenv.hostPlatform.isLinux {
    LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive";
  };

  meta = {
    description = "Natural language calculator library";
    homepage = "https://github.com/vicinaehq/numen";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nolight132 ];
    platforms = lib.platforms.unix;
  };
})
