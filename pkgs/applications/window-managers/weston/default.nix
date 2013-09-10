{ stdenv, fetchurl, pkgconfig, wayland, mesa_full, libxkbcommon
, cairo, libxcb, libXcursor, x11, udev, libdrm, mtdev
, libjpeg, pam, autoconf, automake, libtool, libunwind }:

let version = "1.1.1"; in

stdenv.mkDerivation rec {
  name = "weston-${version}";

  src = fetchurl {
    url = "http://wayland.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "87e1cbbd1a722019ba258d1893c583d96699289196309c93026ae591a2c1f02e";
  };

  buildInputs = [ pkgconfig wayland mesa_full libxkbcommon
    cairo libxcb libXcursor x11 udev libdrm mtdev
    libjpeg pam autoconf automake libtool libunwind ];

  propagatedBuildInputs = [ wayland mesa_full libxkbcommon
    cairo libxcb libXcursor x11 udev libdrm mtdev
    libjpeg pam libunwind ];

  #The C_INCLUDE_PATH is there because 
  preConfigure = ''
    export LIBUNWIND_CFLAGS='-I${libunwind}/include'
    export LIBUNWIND_LIBS='-L${libunwind}/lib -lunwind'
    export COMPOSITOR_CFLAGS='-I${wayland}/include'
    export COMPOSITOR_LIBS='-L${wayland}/lib -lwayland-server -lwayland-cursor'
    export SIMPLE_EGL_CLIENT_CFLAGS='-I${wayland}/include'
    export SIMPLE_EGL_CLIENT_LIBS='-L${wayland}/lib -lwayland-client -lwayland-cursor'
#    export PIXMAN_LIBS='-lpixman-1'
    export LIBS="$LIBS -lGL -lEGL -lwayland-egl -lGLESv2 -lxkbcommon -lpixman-1"
    export C_INCLUDE_PATH='${libdrm}/include/libdrm:${libdrm}/include/libkms'
    autoreconf -vfi
  '';

  # prevent install target to chown root weston-launch, which fails
  configureFlags = ''
    --disable-setuid-install
  '';

  postInstall = ''
    chmod +s $out/bin/weston-launch
  '';

  meta = {
    description = "Reference implementation of a Wayland compositor";
    homepage = http://wayland.freedesktop.org/;
    license = stdenv.lib.licenses.mit;
  };
}
