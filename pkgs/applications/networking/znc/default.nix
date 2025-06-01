{
  lib,
  stdenv,
  fetchurl,
  fetchpatch2,
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
}:

stdenv.mkDerivation rec {
  pname = "znc";
  version = "1.9.1";

  src = fetchurl {
    url = "https://znc.in/releases/archive/${pname}-${version}.tar.gz";
    sha256 = "sha256-6KfPgOGarVELTigur2G1a8MN+I6i4PZPrc3TA8SJTzw=";
  };

  patches = [
    ./module_builds.patch
  ];

  postPatch = ''
    substituteInPlace znc.pc.cmake.in \
      --replace-fail '$'{exec_prefix}/@CMAKE_INSTALL_BINDIR@ @CMAKE_INSTALL_FULL_BINDIR@ \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
    substituteInPlace znc-buildmod-old.cmake.in \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@ \
      --replace-fail @prefix@ $out \
      --replace-fail @openssl@ ${openssl} \
      --replace-fail @icu@ ${icu}
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optional withPerl perl
    ++ lib.optional withPython python3
    ++ lib.optional withTcl tcl
    ++ lib.optional withCyrus cyrus_sasl
    ++ lib.optional withUnicode icu
    ++ lib.optional withZlib zlib;

  configureFlags =
    [
      (lib.enableFeature withPerl "perl")
      (lib.enableFeature withPython "python")
      (lib.enableFeature withTcl "tcl")
      (lib.withFeatureAs withTcl "tcl" "${tcl}/lib")
      (lib.enableFeature withCyrus "cyrus")
    ]
    ++ lib.optionals (!withIPv6) [ "--disable-ipv6" ]
    ++ lib.optionals withDebug [ "--enable-debug" ];

  enableParallelBuilding = true;

  meta = with lib; {
    changelog = "https://github.com/znc/znc/blob/znc-${version}/ChangeLog.md";
    description = "Advanced IRC bouncer";
    homepage = "https://wiki.znc.in/ZNC";
    maintainers = with maintainers; [
      schneefux
      lnl7
    ];
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
