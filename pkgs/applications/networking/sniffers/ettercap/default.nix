{ stdenv, fetchFromGitHub, cmake, libpcap, libnet, zlib, curl, pcre
, openssl, ncurses, glib, gtk3, atk, pango, flex, bison, geoip, harfbuzz
, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "ettercap";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "Ettercap";
    repo = "ettercap";
    rev = "v${version}";
    sha256 = "0m40bmbrv9a8qlg54z3b5f8r541gl9vah5hm0bbqcgyyljpg39bz";
  };

  strictDeps = true;
  nativeBuildInputs = [ cmake flex bison pkgconfig ];
  buildInputs = [
    libpcap libnet zlib curl pcre openssl ncurses
    glib gtk3 atk pango geoip
    harfbuzz
  ];

  preConfigure = ''
    substituteInPlace CMakeLists.txt --replace /etc \$\{INSTALL_PREFIX\}/etc \
                                     --replace /usr \$\{INSTALL_PREFIX\}
  '';

  cmakeFlags = [
    "-DBUNDLED_LIBS=Off"
    "-DGTK3_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
  ];

  NIX_CFLAGS_COMPILE = [ "-I${harfbuzz.dev}/include/harfbuzz" ];

  meta = with stdenv.lib; {
    description = "Comprehensive suite for man in the middle attacks";
    homepage = http://ettercap.github.io/ettercap/;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
  };
}
