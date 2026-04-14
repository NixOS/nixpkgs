{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  cmake,
  libspecbleach,
  lv2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "noise-repellent";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "lucianodato";
    repo = "noise-repellent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GzOUcC161syjazazf+ywssWL0iH17eNhmhTBcjsuaQ0=";
  };

  mesonFlags = [
    "--prefix=${placeholder "out"}/lib/lv2"
    "--buildtype=release"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cmake
  ];
  buildInputs = [
    libspecbleach
    lv2
  ];

  meta = {
    description = "LV2 plugin for broadband noise reduction";
    homepage = "https://github.com/lucianodato/noise-repellent";
    changelog = "https://github.com/lucianodato/noise-repellent/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.unix;
  };
})
