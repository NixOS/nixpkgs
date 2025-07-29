{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  zlib,
  libpng,
  libjpeg,
  libwebp,
  libtiff,
  withXorg ? true,
  libXpm,
  libavif,
  fontconfig,
  freetype,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gd";
  version = "2.3.3";

  src = fetchurl {
    url = "https://github.com/libgd/libgd/releases/download/gd-${finalAttrs.version}/libgd-${finalAttrs.version}.tar.xz";
    hash = "sha256-P+gi7OIHlgYK9jt8YKyxUeWEQgTSidoM4I+P3xMeWmE=";
  };

  patches = [
    (fetchpatch {
      # included in > 2.3.3
      name = "restore-GD_FLIP.patch";
      url = "https://github.com/libgd/libgd/commit/f4bc1f5c26925548662946ed7cfa473c190a104a.diff";
      hash = "sha256-XRXR3NOkbEub3Nybaco2duQk0n8vxif5mTl2AUacn9w=";
    })
  ];

  configureFlags = [
    "--enable-gd-formats"
  ]
  # -pthread gets passed to clang, causing warnings
  ++ lib.optional stdenv.hostPlatform.isDarwin "--enable-werror=no";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    zlib
    freetype
    fontconfig
    libpng
    libjpeg
    libwebp
    libtiff
    libavif
  ]
  ++ lib.optionals withXorg [
    libXpm
  ];

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "gd-(.*)"
    ];
  };

  meta = {
    homepage = "https://libgd.github.io/";
    description = "Dynamic image creation library";
    license = lib.licenses.gd;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
