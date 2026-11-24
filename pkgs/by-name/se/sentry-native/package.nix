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
  version = "0.17.7";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-native";
    tag = finalAttrs.version;
    hash = "sha256-qESxdO7h/Q2/9ZVVICX+iJD3uTrQaBmni6sLwGkqKig=";
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
