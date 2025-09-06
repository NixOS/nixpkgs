# To use this package with a CMake and pkg-config build:
# pkg_check_modules(EASYLOGGINGPP REQUIRED easyloggingpp)
# add_executable(main src/main.cpp ${EASYLOGGINGPP_PREFIX}/include/easylogging++.cc)
{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "easyloggingpp";
  version = "9.97.1";

  src = fetchFromGitHub {
    owner = "abumq";
    repo = "easyloggingpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R4NdwsUywgJoK5E/OdZXFds6iBKOsMa0E+2PDdQbV6E=";
  };

  nativeBuildInputs = [ cmake ];

  nativeCheckInputs = [ gtest ];

  cmakeFlags = [ (lib.cmakeBool "test" finalAttrs.doCheck) ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isLinux " -pthread";

  doCheck = true;

  env.GTEST_FILTER =
    # https://github.com/abumq/easyloggingpp/issues/816
    "-CommandLineArgsTest.LoggingFlagsArg";

  meta = {
    description = "C++ logging library";
    homepage = "https://github.com/abumq/easyloggingpp";
    changelog = "https://github.com/abumq/easyloggingpp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ acowley ];
    platforms = lib.platforms.all;
  };
})
