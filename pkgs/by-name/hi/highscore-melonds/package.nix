{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libhighscore,
  enet,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "highscore-melonds";
  version = "0-unstable-2026-05-07";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "melonDS";
    rev = "003d0545edbfed3f0385177a800e3e1304845fed";
    hash = "sha256-t8MedX/IpBYrUQJ5qmT7e8O9mTlL2i/CpWBx0vIsUag=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libhighscore
    enet
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_QT_SDL" false)
    (lib.cmakeBool "ENABLE_GDBSTUB" false)
    (lib.cmakeBool "BUILD_HIGHSCORE" true)
  ];

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Port of melonDS to Highscore";
    homepage = "https://github.com/highscore-emu/melonDS";
    license = lib.licenses.gpl3Plus;
    inherit (libhighscore.meta) maintainers platforms;
  };
}
