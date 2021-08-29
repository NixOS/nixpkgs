{ lib, stdenv, fetchurl, intltool, glib, pkg-config, udev, util-linux, acl }:
stdenv.mkDerivation {
  name = "udevil-0.4.4";
  src = fetchurl {
    url = "https://github.com/IgnorantGuru/udevil/archive/0.4.4.tar.gz";
    sha256 = "0z1bhaayambrcn7bgnrqk445k50ifabmw8q4i9qj49nnbcvxhbxd";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ intltool glib udev ];
  configurePhase = ''
    substituteInPlace src/Makefile.in --replace "-o root -g root" ""
    # do not set setuid bit in nix store
    substituteInPlace src/Makefile.in --replace 4755 0755
    ./configure \
      --prefix=$out \
      --with-mount-prog=${util-linux}/bin/mount \
      --with-umount-prog=${util-linux}/bin/umount \
      --with-losetup-prog=${util-linux}/bin/losetup \
      --with-setfacl-prog=${acl.bin}/bin/setfacl \
      --sysconfdir=$prefix/etc
  '';
  patches = [ ./device-info-sys-stat.patch ];
  meta = {
    description = "A command line Linux program which mounts and unmounts removable devices without a password, shows device info, and monitors device changes";
    homepage = "https://ignorantguru.github.io/udevil/";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3;
  };
}
