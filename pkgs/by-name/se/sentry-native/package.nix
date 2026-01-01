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
<<<<<<< HEAD
  version = "0.12.2";
=======
  version = "0.12.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-native";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-G5h30KZVkRYwW84Si0I8qSgDuPTfFqQMoyctKB8Kq1s=";
=======
    hash = "sha256-zjg5WSa/zKIyFmkXsmtghHaPoexxqE7m9kAA5V9f5Nc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
