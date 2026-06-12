{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  libsodium,
  mbedtls,
  libev,
  c-ares,
  pcre2,
  asciidoc,
  xmlto,
  docbook_xml_dtd_45,
  docbook_xsl,
  libxslt,
  nixosTests,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "shadowsocks-libev";
  version = "3.3.6";

  # Git tag includes CMake build files which are much more convenient.
  src = fetchFromGitHub {
    owner = "shadowsocks";
    repo = "shadowsocks-libev";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XrS/qi4oAchdisvicrGmpe3jeDgYDACsvVU6iXQyQCM=";
    fetchSubmodules = true;
  };

  buildInputs = [
    libsodium
    mbedtls
    libev
    c-ares
    pcre2
  ];
  nativeBuildInputs = [
    cmake
    asciidoc
    xmlto
    docbook_xml_dtd_45
    docbook_xsl
    libxslt
  ];

  cmakeFlags = [
    (lib.cmakeBool "WITH_STATIC" false)
    (lib.cmakeBool "-DCMAKE_BUILD_WITH_INSTALL_NAME_DIR" true)
    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    (lib.cmakeBool "-DCMAKE_SKIP_BUILD_RPATH" true)
  ];

  postPatch = ''
    substituteInPlace cmake/shadowsocks-libev.pc.cmake \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@ \

    # https://github.com/dcreager/libcork/issues/173 but needs a different patch (yay vendoring)
    substituteInPlace libcork/src/libcork.pc.in \
      --replace-fail '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  postInstall = ''
    cp lib/* $out/lib
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = lib.recurseIntoAttrs {
      inherit (nixosTests.shadowsocks) basic-libev v2ray-plugin-libev;
    };
  };

  meta = {
    description = "Lightweight secured SOCKS5 proxy";
    longDescription = ''
      Shadowsocks-libev is a lightweight secured SOCKS5 proxy for embedded devices and low-end boxes.
      It is a port of Shadowsocks created by @clowwindy, which is maintained by @madeye and @linusyang.
    '';
    homepage = "https://github.com/shadowsocks/shadowsocks-libev";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ hmenke ];
    platforms = lib.platforms.all;
    hasNoMaintainersButDependents = true;
  };
})
