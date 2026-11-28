{
  lib,
  stdenv,
  fetchFromGitHub,
  cmark-gfm,
  xxd,
  libfastjson,
  libzip,
  ninja,
  meson,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mmdoc";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "ryantm";
    repo = "mmdoc";
    rev = finalAttrs.version;
    hash = "sha256-aq/+/geFENuDHk5yu6eFw5/TKpAANMO0kVcdq8uSW/c=";
  };

  nativeBuildInputs = [
    ninja
    meson
    pkg-config
    xxd
  ];

  buildInputs = [
    cmark-gfm
    libfastjson
    libzip
  ];

  meta = {
    description = "Minimal Markdown Documentation";
    mainProgram = "mmdoc";
    homepage = "https://github.com/ryantm/mmdoc";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ ryantm ];
    platforms = lib.platforms.unix;
  };
})
