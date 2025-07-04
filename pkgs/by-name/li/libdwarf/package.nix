{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  zlib,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdwarf";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "davea42";
    repo = "libdwarf-code";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SsFg+7zGBEGxDSzfiIP5bxdttlBkhEiEQWaU12hINas=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  buildInputs = [
    zlib
    zstd
  ];

  outputs = [
    "bin"
    "lib"
    "dev"
    "out"
  ];

  meta = {
    description = "Library for reading DWARF2 and later DWARF";
    mainProgram = "dwarfdump";
    homepage = "https://github.com/davea42/libdwarf-code";
    changelog = "https://github.com/davea42/libdwarf-code/releases/tag/v${finalAttrs.version}/CHANGELOG.md";
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.atry ];
  };
})
