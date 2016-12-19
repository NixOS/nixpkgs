{ stdenv, fetchFromGitHub, cmake, libpcap, libnet, zlib, curl, pcre,
  openssl, ncurses, glib, gtk2, atk, pango, flex, bison }:

stdenv.mkDerivation rec {
  name = "ettercap-${version}";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "Ettercap";
    repo = "ettercap";
    rev = "v${version}";
    sha256 = "1kvrzv2f8kxy7pndfadkzv10cs5wsyfkaa1ski20r2mq4wrvd0cd";
  };

  buildInputs = [
    cmake libpcap libnet zlib curl pcre openssl ncurses
    glib gtk2 atk pango flex bison
  ];

  preConfigure = ''
    substituteInPlace CMakeLists.txt --replace /etc \$\{INSTALL_PREFIX\}/etc \
                                     --replace /usr \$\{INSTALL_PREFIX\}
  '';

  cmakeFlags = [
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
  ];

  meta = with stdenv.lib; {
    description = "Comprehensive suite for man in the middle attacks";
    homepage = http://ettercap.github.io/ettercap/;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
  };
}
