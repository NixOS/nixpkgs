{ lib, stdenv, fetchFromGitHub, intltool, glib, pkg-config, udev, util-linux, acl }:

stdenv.mkDerivation rec {
  pname = "udevil";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "IgnorantGuru";
    repo = "udevil";
    rev = version;
    sha256 = "0nd44r8rbxifx4x4m24z5aji1c6k1fhw8cmf5s43wd5qys0bcdad";
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

  postInstall = ''
    substituteInPlace $out/lib/systemd/system/devmon@.service \
      --replace /usr/bin/devmon "$out/bin/devmon"
  '';

  patches = [ ./device-info-sys-stat.patch ];

  meta = with lib; {
    description = "A command line Linux program which mounts and unmounts removable devices without a password, shows device info, and monitors device changes";
    homepage = "https://ignorantguru.github.io/udevil/";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}
