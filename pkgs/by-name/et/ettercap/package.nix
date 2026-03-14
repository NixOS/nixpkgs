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
  versionCheckHook,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ettercap";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "Ettercap";
    repo = "ettercap";
    rev = finalAttrs.version;
    hash = "sha256-T3LsOD2LGbk4f5un3l5Ybf5/kgYQJfw7lGa2UXB/brY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    bison
    cmake
    flex
    pkg-config
    versionCheckHook
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

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  preConfigure = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail /etc \$\{INSTALL_PREFIX\}/etc \
      --replace-fail /usr \$\{INSTALL_PREFIX\}
  '';

  cmakeFlags = [
    "-DBUNDLED_LIBS=Off"
    "-DGTK3_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
  ];

  meta = {
    description = "Comprehensive suite for man in the middle attacks";
    longDescription = ''
      Ettercap is a comprehensive suite for man in the middle attacks. It
      features sniffing of live connections, content filtering on the fly and
      many other interesting tricks. It supports active and passive dissection
      of many protocols and includes many features for network and host
      analysis.
    '';
    homepage = "https://www.ettercap-project.org/";
    changelog = "https://github.com/Ettercap/ettercap/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "ettercap";
    maintainers = with lib.maintainers; [
      pSub
      makefu
    ];
  };
})
