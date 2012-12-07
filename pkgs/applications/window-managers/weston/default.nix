{ stdenv, fetchurl, pkgconfig, wayland, mesa90x, libxkbcommon, pixman
, cairo, libxcb, libXcursor, x11, udev, libdrm2_4_39, mtdev
, libjpeg, pam, autoconf, automake, libtool }:

let version = "1.0.2"; in

stdenv.mkDerivation rec {
  name = "weston-${version}";

  src = fetchurl {
    url = "http://wayland.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "1496l8hmpxx7pivdpp14pv0hi30q18dmnaxz471v9jiqsnnrr11k";
  };

  patches = [
    ./screenshooter-client-protocol_h.patch
    ./makefile.patch
  ];

  buildInputs = [ pkgconfig wayland mesa90x libxkbcommon pixman
    cairo libxcb libXcursor x11 udev libdrm2_4_39 mtdev
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
