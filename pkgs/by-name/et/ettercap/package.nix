{
  lib,
  stdenv,
  atk,
  bison,
  cmake,
  curl,
  fetchFromGitHub,
  flex,
  geoip,
  glib,
  gtk3,
  harfbuzz,
  libmaxminddb,
  libnet,
  libpcap,
  ncurses,
  openssl,
  pango,
  pcre2,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "ettercap";
  version = "0.8.4-unstable-2025-07-16";

  src = fetchFromGitHub {
    owner = "Ettercap";
    repo = "ettercap";
    rev = "26ef2d2e1432b866460f9c4ddf9e4dce3db1a5ab";
    hash = "sha256-T3LsOD2LGbk4f5un3l5Ybf5/kgYQJfw7lGa2UXB/brY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    bison
    cmake
    flex
    pkg-config
  ];

  buildInputs = [
    atk
    curl
    geoip
    glib
    gtk3
    harfbuzz
    libmaxminddb
    libnet
    libpcap
    ncurses
    openssl
    pango
    pcre2
    zlib
  ];

  preConfigure = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail /etc \$\{INSTALL_PREFIX\}/etc \
      --replace-fail /usr \$\{INSTALL_PREFIX\}
  '';

  cmakeFlags = [
    "-DBUNDLED_LIBS=Off"
    "-DGTK3_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
  ];

  # TODO: Remove after the next release (0.8.4 should work without this):
  env.NIX_CFLAGS_COMPILE = toString [ "-I${harfbuzz.dev}/include/harfbuzz" ];

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
    changelog = "https://github.com/Ettercap/ettercap/releases/tag/${version}";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
  };
}
