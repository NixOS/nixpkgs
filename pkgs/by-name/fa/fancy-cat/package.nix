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
  zig,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fancy-cat";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "freref";
    repo = "fancy-cat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ziHtPfK9GOxKF800kk+kh12Fwh91xbjDYx9wv2pLZWI=";
  };

  patches = [ ./0001-changes.patch ];

  nativeBuildInputs = [
    zig.hook
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

  postPatch = ''
    ln -s ${callPackage ./build.zig.zon.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  meta = {
    description = "PDF viewer for terminals using the Kitty image protocol";
    homepage = "https://github.com/freref/fancy-cat";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ ciflire ];
    mainProgram = "fancy-cat";
    inherit (zig.meta) platforms;
  };
})
