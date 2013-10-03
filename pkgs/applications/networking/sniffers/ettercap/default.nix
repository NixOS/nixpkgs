{ stdenv, fetchurl, cmake, libpcap, libnet, zlib, curl, pcre,
  openssl, ncurses, glib, gtk, atk, pango, flex, bison }:

stdenv.mkDerivation rec {
  name = "ettercap-${version}";
  version = "0.8.0";

  src = fetchurl {
    url = "https://github.com/Ettercap/ettercap/archive/v${version}.tar.gz";
    sha256 = "1g69782wk2hag8h76jqy81szw5jhvqqnn3m4v0wjkbv9zjxy44w0";
  };

  buildInputs = [
    cmake libpcap libnet zlib curl pcre openssl ncurses
    glib gtk atk pango flex bison
  ];

  preConfigure = ''
    substituteInPlace CMakeLists.txt --replace /etc \$\{INSTALL_PREFIX\}/etc
  '';

  cmakeFlags = [
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib}/lib/glib-2.0/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk}/lib/gtk-2.0/include"
  ];

  meta = {
    description = "Ettercap is a comprehensive suite for man in the middle attacks.";
    homepage = http://ettercap.github.io/ettercap/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
  };
}
