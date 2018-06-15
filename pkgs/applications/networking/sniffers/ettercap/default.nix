{ stdenv, fetchFromGitHub, cmake, libpcap, libnet, zlib, curl, pcre
, openssl, ncurses, glib, gtk2, atk, pango, flex, bison
, fetchpatch }:

stdenv.mkDerivation rec {
  name = "ettercap-${version}";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "Ettercap";
    repo = "ettercap";
    rev = "v${version}";
    sha256 = "1kvrzv2f8kxy7pndfadkzv10cs5wsyfkaa1ski20r2mq4wrvd0cd";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2017-8366.patch";
      url = "https://github.com/Ettercap/ettercap/commit/1083d604930ebb9f350126b83802ecd2cbc17f90.patch";
      sha256 = "1ff6fp8fxisvd3fkkd01y4fjykgcj414kczzpfscdmi52ridwg8m";
    })
    (fetchpatch {
      name = "CVE-2017-6430.patch";
      url = "https://github.com/Ettercap/ettercap/commit/7f50c57b2101fe75592c8dc9960883bbd1878bce.patch";
      sha256 = "0s13nc9yzxzp611rixsd1c8aw1b57q2lnvfq8wawxyrw07h7b2j4";
    })
  ];

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
