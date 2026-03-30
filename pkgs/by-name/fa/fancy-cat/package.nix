{
  fetchFromGitHub,
  freetype,
  gumbo,
  harfbuzz,
  jbig2dec,
  lib,
  libjpeg,
  libz,
  mujs,
  mupdf,
  openjpeg,
  pkg-config,
  stdenv,
  zig_0_15,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fancy-cat";
  version = "0.5.0-unstable-2025-11-17";

  src = fetchFromGitHub {
    owner = "freref";
    repo = "fancy-cat";
    rev = "9094d1165bd5ee41f264553d9630c5db40b2fad9";
    hash = "sha256-mCaeL0wZCfNpTT63nNGJz54LmvbcorUHCqBET8j3uNQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    zig_0_15.hook
    pkg-config
  ];

  zigBuildFlags = [ "--release=fast" ];

  buildInputs = [
    mupdf
    harfbuzz
    freetype
    jbig2dec
    libjpeg
    openjpeg
    gumbo
    mujs
    libz
  ];

  zigDeps = zig_0_15.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-755vjT5pZGg4GXTHsDd6+VtAnbEhSPopKFVo0OcP/Kg=";
  };

  meta = {
    description = "PDF viewer for terminals using the Kitty image protocol";
    homepage = "https://github.com/freref/fancy-cat";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ ciflire ];
    mainProgram = "fancy-cat";
    inherit (zig_0_15.meta) platforms;
  };
})
