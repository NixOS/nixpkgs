{ lib
, stdenv
, fetchFromGitHub
, acl
, glib
, intltool
, pkg-config
, udev
, util-linux
}:

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

  buildInputs = [
    glib
    intltool
    udev
  ];

  preConfigure = ''
    substituteInPlace src/Makefile.in --replace "-o root -g root" ""
    # do not set setuid bit in nix store
    substituteInPlace src/Makefile.in --replace 4755 0755
  '';

  configureFlags = [
    "--with-mount-prog=${util-linux}/bin/mount"
    "--with-umount-prog=${util-linux}/bin/umount"
    "--with-losetup-prog=${util-linux}/bin/losetup"
    "--with-setfacl-prog=${acl.bin}/bin/setfacl"
    "--sysconfdir=${placeholder "out"}/etc"
  ];

  postInstall = ''
    substituteInPlace $out/lib/systemd/system/devmon@.service \
      --replace /usr/bin/devmon "$out/bin/devmon"
  '';

  patches = [
    # sys/stat.h header missing on src/device-info.h
    ./device-info-sys-stat.patch
  ];

  meta = with lib; {
    homepage = "https://ignorantguru.github.io/udevil/";
    description = "Mount without password";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
}
