{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  fuse3,
  xz,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "avfs";
  version = "1.4.0";
  src = fetchurl {
    url = "mirror://sourceforge/avf/${finalAttrs.version}/avfs-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-1Nza9a/XuhRjNLbQA2ADQAEclzB9hCKezgn+aERI+Y4=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    fuse3
    xz
    zlib
  ];

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-function-pointer-types";
  };

  configureFlags = [
    "--enable-library"
    "--enable-fuse"
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin "--with-system-zlib";

  meta = {
    homepage = "https://avf.sourceforge.net/";
    description = "Virtual filesystem that allows browsing of compressed files";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ tbutter ];
  };
})
