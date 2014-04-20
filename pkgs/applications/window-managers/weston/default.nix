{ stdenv, fetchurl, pkgconfig, wayland, mesa, libxkbcommon
, cairo, libxcb, libXcursor, x11, udev, libdrm, mtdev
, libjpeg, pam, autoconf, automake, libtool, dbus }:

let version = "1.4.0"; in

stdenv.mkDerivation rec {
  name = "weston-${version}";

  src = fetchurl {
    url = "http://wayland.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "0r7dz72ys9p3f697ajgmihkar2da36bnjna6yanb3kg9k2fk38kl";
  };

  buildInputs = [
    pkgconfig wayland mesa libxkbcommon
    cairo libxcb libXcursor x11 udev libdrm mtdev libjpeg pam dbus.libs
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
