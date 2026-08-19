{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  zlib,
  zstd,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdwarf";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "davea42";
    repo = "libdwarf-code";
    tag = "v${finalAttrs.version}";
    hash = "sha256-65jEnM+eJ7HnZlpEM2D67W0Xgb9B/aa4JhajowG0Z8o=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
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
