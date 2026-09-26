{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  breakpad,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sentry-native";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-native";
    tag = finalAttrs.version;
    hash = "sha256-LmEp9I3pUklDt49HqfVO/v/H7Gv83Wug9wmI2hHof0o=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    curl
    breakpad
  ];

  cmakeBuildType = "RelWithDebInfo";

  cmakeFlags = [
    "-DSENTRY_BREAKPAD_SYSTEM=On"
    "-DSENTRY_BACKEND=breakpad"
  ];

  meta = {
    homepage = "https://github.com/getsentry/sentry-native";
    description = "Sentry SDK for C, C++ and native applications";
    changelog = "https://github.com/getsentry/sentry-native/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      wheelsandmetal
      daniel-fahey
    ];
  };
})
