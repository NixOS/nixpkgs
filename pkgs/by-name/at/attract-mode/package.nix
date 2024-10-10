{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  expat,
  ffmpeg_7,
  freetype,
  libarchive,
  libjpeg,
  libGLU,
  sfml,
  zlib,
  openal,
  fontconfig,
  darwin,
}:

stdenv.mkDerivation {
  pname = "attract-mode";
  version = "2.7.0-unstable-2024-08-02";

  src = fetchFromGitHub {
    owner = "mickelson";
    repo = "attract";
    rev = "6ed3a1e32a519608c0b495295cc4c18ceea6b461";
    hash = "sha256-uhbu/DaQSE9Dissv7XLFMVYitPn8ZEewq90poCtEfYY=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      expat
      ffmpeg_7
      freetype
      libarchive
      libjpeg
      libGLU
      sfml
      zlib
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      openal
      fontconfig
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Cocoa
      darwin.apple_sdk.frameworks.Carbon
      darwin.apple_sdk.frameworks.IOKit
      darwin.apple_sdk.frameworks.CoreVideo
      darwin.apple_sdk.frameworks.OpenAL
    ];

  makeFlags = [
    "prefix=$(out)"
    "CC=${stdenv.cc.targetPrefix}cc"
    "CXX=${stdenv.cc.targetPrefix}c++"
    "STRIP=${stdenv.cc.targetPrefix}strip"
    "OBJCOPY=${stdenv.cc.targetPrefix}objcopy"
    "PKG_CONFIG=${stdenv.cc.targetPrefix}pkg-config"
    "AR=${stdenv.cc.targetPrefix}ar"
    "BUILD_EXPAT=0"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ "USE_FONTCONFIG=0" ];

  enableParallelBuilding = true;

  meta = {
    description = "Frontend for arcade cabinets and media PCs";
    homepage = "http://attractmode.org";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.hrdinka ];
    platforms = lib.platforms.unix;
    mainProgram = "attract";
  };
}
