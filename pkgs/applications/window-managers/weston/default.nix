{ stdenv, fetchurl, pkgconfig, wayland, mesa, libxkbcommon
, cairo, libxcb, libXcursor, x11, udev, libdrm, mtdev
, libjpeg, pam, autoconf, automake, libtool }:

let version = "1.3.1"; in

stdenv.mkDerivation rec {
  name = "weston-${version}";

  src = fetchurl {
    url = "http://wayland.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "1isvh66irrz707r69495767n5yxp07dvy0xx6mj1mbj1n4s1657p";
  };

  buildInputs = [
    pkgconfig wayland mesa libxkbcommon
    cairo libxcb libXcursor x11 udev libdrm mtdev libjpeg pam
  ];

  NIX_CFLAGS_COMPILE = "-I${libdrm}/include/libdrm";

  configureFlags = [
    "--disable-setuid-install" # prevent install target to chown root weston-launch, which fails
  ];

  meta = {
    description = "Reference implementation of a Wayland compositor";
    homepage = http://wayland.freedesktop.org/;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
  };
}
