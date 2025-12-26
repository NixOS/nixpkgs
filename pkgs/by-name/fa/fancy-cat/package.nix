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
  zig_0_14,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fancy-cat";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "freref";
    repo = "fancy-cat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Wasxhsv4QhGscOEsGirabsq92963S8v1vOBWvAFuRoM=";
  };

  patches = [ ./0001-changes.patch ];

  nativeBuildInputs = [
    zig_0_14.hook
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
    broken = true; # build phase wants to fetch from github
    description = "PDF viewer for terminals using the Kitty image protocol";
    homepage = "https://github.com/freref/fancy-cat";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ ciflire ];
    mainProgram = "fancy-cat";
    inherit (zig_0_14.meta) platforms;
  };
})
