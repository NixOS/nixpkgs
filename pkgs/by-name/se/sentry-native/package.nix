{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  breakpad,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "sentry-native";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-native";
    tag = version;
    hash = "sha256-99C4Nd2YdUElMpbKrNIBjicaWHR2MVqHUu5KryYAT/I=";
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
    changelog = "https://github.com/getsentry/sentry-native/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      wheelsandmetal
      daniel-fahey
    ];
  };
}
