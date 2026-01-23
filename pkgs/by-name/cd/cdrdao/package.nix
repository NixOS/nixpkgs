{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  libiconv,
  libvorbis,
  libmad,
  libao,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cdrdao";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "cdrdao";
    repo = "cdrdao";
    tag = "rel_${lib.replaceString "." "_" finalAttrs.version}";
    hash = "sha256-XEaJsv3c/xPO6jclJBbTopOnYamIOlumD2B+hJZraEE=";
  };

  makeFlags = [
    "RM=rm"
    "LN=ln"
    "MV=mv"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libiconv
    libvorbis
    libmad
    libao
  ];

  hardeningDisable = [ "format" ];

  # we have glibc/include/linux as a symlink to the kernel headers,
  # and the magic '..' points to kernelheaders, and not back to the glibc/include
  postPatch = ''
    sed -i 's,linux/../,,g' dao/sg_err.h
  '';

  # Needed on gcc >= 6.
  env.NIX_CFLAGS_COMPILE = "-Wno-narrowing";

  meta = {
    description = "Tool for recording audio or data CD-Rs in disk-at-once (DAO) mode";
    homepage = "https://github.com/cdrdao/cdrdao";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
  };
})
