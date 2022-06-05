{ lib, stdenv, fetchFromGitHub, cmake, libpcap, libnet, zlib, curl, pcre
, openssl, ncurses, glib, gtk3, atk, pango, flex, bison, geoip, harfbuzz
, pkg-config }:

stdenv.mkDerivation rec {
  pname = "ettercap";
  version = "0.8.3.1";

  src = fetchFromGitHub {
    owner = "Ettercap";
    repo = "ettercap";
    rev = "v${version}";
    sha256 = "1sdf1ssa81ib6k0mc5m2jzbjl4jd1yv6ahv5dwx2x9w4b2pyqg1c";
  };

  strictDeps = true;
  nativeBuildInputs = [ cmake flex bison pkg-config ];
  buildInputs = [
    libpcap libnet zlib curl pcre openssl ncurses
    glib gtk3 atk pango geoip harfbuzz
  ];

  preConfigure = ''
    substituteInPlace CMakeLists.txt --replace /etc \$\{INSTALL_PREFIX\}/etc \
                                     --replace /usr \$\{INSTALL_PREFIX\}
  '';

  cmakeFlags = [
    "-DBUNDLED_LIBS=Off"
    "-DGTK3_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
  ];

  # TODO: Remove after the next release (0.8.4 should work without this):
  NIX_CFLAGS_COMPILE = [ "-I${harfbuzz.dev}/include/harfbuzz" ];

  meta = with lib; {
    description = "Comprehensive suite for man in the middle attacks";
    longDescription = ''
      Ettercap is a comprehensive suite for man in the middle attacks. It
      features sniffing of live connections, content filtering on the fly and
      many other interesting tricks. It supports active and passive dissection
      of many protocols and includes many features for network and host
      analysis.
    '';
    homepage = "https://www.ettercap-project.org/";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
  };
}
