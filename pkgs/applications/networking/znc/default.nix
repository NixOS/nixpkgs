{
  lib,
  stdenv,
  fetchurl,
  cmake,
  openssl,
  pkg-config,
  withPerl ? false,
  perl,
  withPython ? false,
  python3,
  withTcl ? false,
  tcl,
  withCyrus ? true,
  cyrus_sasl,
  withUnicode ? true,
  icu,
  withZlib ? true,
  zlib,
  withIPv6 ? true,
  withDebug ? false,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "znc";
  version = "1.10.1";

  src = fetchurl {
    url = "https://znc.in/releases/archive/znc-${finalAttrs.version}.tar.gz";
    hash = "sha256-Tm52hR2/JgYYWXK1PsXeytaP5TtjpW5N+LizwKbEaAA=";
  };

  postPatch = ''
    substituteInPlace znc.pc.cmake.in \
      --replace-fail 'bindir=''${exec_prefix}/@CMAKE_INSTALL_BINDIR@' "bindir=@CMAKE_INSTALL_FULL_BINDIR@" \
      --replace-fail 'libdir=''${prefix}/@CMAKE_INSTALL_LIBDIR@' "libdir=@CMAKE_INSTALL_FULL_LIBDIR@" \
      --replace-fail 'datadir=''${prefix}/@CMAKE_INSTALL_DATADIR@' "datadir=@CMAKE_INSTALL_FULL_DATADIR@" \
      --replace-fail 'includedir=''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@' "includedir=@CMAKE_INSTALL_FULL_INCLUDEDIR@" \
      --replace-fail 'datarootdir=''${prefix}/@CMAKE_INSTALL_DATAROOTDIR@' "datarootdir=@CMAKE_INSTALL_FULL_DATAROOTDIR@"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optional withPerl perl
  ++ lib.optional withPython python3
  ++ lib.optional withTcl tcl
  ++ lib.optional withCyrus cyrus_sasl
  ++ lib.optional withUnicode icu
  ++ lib.optional withZlib zlib;

  configureFlags = [
    (lib.enableFeature withPerl "perl")
    (lib.enableFeature withPython "python")
    (lib.enableFeature withTcl "tcl")
    (lib.withFeatureAs withTcl "tcl" "${tcl}/lib")
    (lib.enableFeature withCyrus "cyrus")
  ]
  ++ lib.optionals (!withIPv6) [ "--disable-ipv6" ]
  ++ lib.optionals withDebug [ "--enable-debug" ];

  enableParallelBuilding = true;

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Advanced IRC bouncer";
    homepage = "https://wiki.znc.in/ZNC";
    maintainers = with lib.maintainers; [
      lnl7
    ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "znc" ];
  };
})
