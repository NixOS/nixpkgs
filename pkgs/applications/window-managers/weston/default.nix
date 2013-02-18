{ stdenv, fetchurl, pkgconfig, wayland, mesa, libxkbcommon, pixman
, cairo, libxcb, libXcursor, x11, udev, libdrm, mtdev
, libjpeg, pam, autoconf, automake, libtool }:

let version = "1.0.5"; in

stdenv.mkDerivation rec {
  name = "weston-${version}";

  src = fetchurl {
    url = "http://wayland.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "0g2k82pnlxl8b70ykazj7kn8xffjfsmgcgx427qdrm4083z2hgm0";
  };

  buildInputs = [ pkgconfig wayland mesa libxkbcommon pixman
    cairo libxcb libXcursor x11 udev libdrm mtdev
    libjpeg pam autoconf automake libtool ];

  preConfigure = "autoreconf -vfi";

  # prevent install target to chown root weston-launch, which fails
  configureFlags = ''
    --disable-setuid-install
  '';

  meta = {
    description = "Reference implementation of a Wayland compositor";
    homepage = http://wayland.freedesktop.org/;
    license = stdenv.lib.licenses.mit;
  };
}
