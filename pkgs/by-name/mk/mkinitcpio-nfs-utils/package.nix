{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mkinitcpio-nfs-utils";
  version = "0.3";

  src = fetchurl {
    url = "https://sources.archlinux.org/other/mkinitcpio/mkinitcpio-nfs-utils-${finalAttrs.version}.tar.xz";
    sha256 = "0fc93sfk41ycpa33083kyd7i4y00ykpbhj5qlw611bjghj4x946j";
    # ugh, upstream...
    name = "mkinitcpio-nfs-utils-${finalAttrs.version}.tar.gz";
  };

  makeFlags = [
    "DESTDIR=$(out)"
    "bindir=/bin"
  ];

  postInstall = ''
    rm -rf $out/usr
  '';

  meta = {
    homepage = "https://archlinux.org/";
    description = "ipconfig and nfsmount tools for root on NFS, ported from klibc";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
