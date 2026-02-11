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
  breakpointHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fancy-cat";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "freref";
    repo = "fancy-cat";
    rev = "9094d1165bd5ee41f264553d9630c5db40b2fad9";
    hash = "sha256-mCaeL0wZCfNpTT63nNGJz54LmvbcorUHCqBET8j3uNQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    zig_0_15
    mupdf
    harfbuzz
    freetype
    jbig2dec
    libjpeg
    openjpeg
    gumbo
    mujs
    libz
    # breakpointHook
  ];

  # zigBuildFlags = [
  #   "--release=fast"
  #   "-Dcpu=skylake"
  # ];

  dontSetZigDefaultFlags = true;

  postConfigure = ''
    ln -s ${callPackage ./deps.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  meta = {
    # broken = true; # build phase wants to fetch from github
    description = "PDF viewer for terminals using the Kitty image protocol";
    homepage = "https://github.com/freref/fancy-cat";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ ciflire ];
    mainProgram = "fancy-cat";
    inherit (zig_0_15.meta) platforms;
  };
})
