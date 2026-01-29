{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  fuse,
  libmtp,
  glib,
  libmad,
  libid3tag,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mtpfs";
  version = "1.1";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    fuse
    libmtp
    glib
    libid3tag
    libmad
  ];

  src = fetchurl {
    url = "https://www.adebenham.com/files/mtp/mtpfs-${finalAttrs.version}.tar.gz";
    sha256 = "07acrqb17kpif2xcsqfqh5j4axvsa4rnh6xwnpqab5b9w5ykbbqv";
  };

  meta = {
    homepage = "https://github.com/cjd/mtpfs";
    description = "FUSE Filesystem providing access to MTP devices";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.qknight ];
    broken = stdenv.hostPlatform.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/mtpfs.x86_64-darwin
    mainProgram = "mtpfs";
  };
})
