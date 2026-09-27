{
  callPackage,
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
  stdenv,
  zig_0_15,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fancy-cat";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "freref";
    repo = "fancy-cat";
    tag = "v0.6.0";
    hash = "sha256-dyMcPIg1Wy9aOudDCVuDUqr8XkrO1kVtOEPBErosGwA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    zig_0_15
  ];

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

  dontSetZigDefaultFlags = true;

  deps = callPackage ./deps.nix { };

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ];

  meta = {
    description = "PDF viewer for terminals using the Kitty image protocol";
    homepage = "https://github.com/freref/fancy-cat";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ ciflire ];
    mainProgram = "fancy-cat";
    inherit (zig_0_15.meta) platforms;
  };
})
