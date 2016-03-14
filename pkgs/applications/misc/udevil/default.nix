{ stdenv, fetchurl, intltool, glib, pkgconfig, udev, utillinux, acl }:
stdenv.mkDerivation {
  name = "udevil-0.4.4";
  src = fetchurl {
    url = https://github.com/IgnorantGuru/udevil/archive/0.4.4.tar.gz;
    sha256 = "0z1bhaayambrcn7bgnrqk445k50ifabmw8q4i9qj49nnbcvxhbxd";
  };
  buildInputs = [ intltool glib pkgconfig udev ];
  configurePhase = ''
    substituteInPlace src/Makefile.am --replace "-o root -g root" ""
    substituteInPlace src/Makefile.in --replace "-o root -g root" ""
    ./configure \
      --prefix=$out \
      --with-mount-prog=${utillinux}/bin/mount \
      --with-umount-prog=${utillinux}/bin/umount \
      --with-losetup-prog=${utillinux}/bin/losetup \
      --with-setfacl-prog=${acl.bin}/bin/setfacl \
      --sysconfdir=$prefix/etc
  '';
  preConfigure = ''
    cat src/Makefile.am
    exit 2
  '';
  patches = [ ./device-info-sys-stat.patch ];
  meta = {
    description = "A command line Linux program which mounts and unmounts removable devices without a password, shows device info, and monitors device changes";
    homepage = https://ignorantguru.github.io/udevil/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl3;
  };
}
