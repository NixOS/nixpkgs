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
  stdenv,
  zig_0_15,
}:

let
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "freref";
    repo = "fancy-cat";
    tag = "v${version}";
    hash = "sha256-p5q4SM0eFwVS9O+gXI6q694j7Cg7KmCqN6t0uPCdMPk=";
  };

  zig-cache = stdenv.mkDerivation {
    pname = "zig-cache";
    inherit src version;
    strictDeps = true;

    nativeBuildInputs = [ zig_0_15 ];
    dontInstall = true;

    buildPhase = ''
      mkdir -p $out
      zig build \
        --fetch \
        --global-cache-dir $out
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-CXNJrTcQ7GwnFXVdTo/lxM6KWPrTuqt0FaoIR/uJ3G8=";
  };
in

stdenv.mkDerivation {
  pname = "fancy-cat";
  inherit src version;

  patches = [ ./0001-changes.patch ];

  nativeBuildInputs = [ zig_0_15.hook ];

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

  zigBuildFlags = [ "-Doptimize=ReleaseFast" ];

  preBuild = ''
    mkdir -p $TMPDIR/zig-cache
    cp -r ${zig-cache}/* $TMPDIR/zig-cache/
    chmod -R u+w $TMPDIR/zig-cache

    export ZIG_GLOBAL_CACHE_DIR=$TMPDIR/zig-cache
  '';

  meta = {
    description = "PDF viewer for terminals using the Kitty image protocol";
    homepage = "https://github.com/freref/fancy-cat";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ ciflire ];
    mainProgram = "fancy-cat";
    inherit (zig_0_15.meta) platforms;
  };
}
