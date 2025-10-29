{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libsodium,
  mbedtls_2,
  libev,
  c-ares,
  pcre,
  asciidoc,
  xmlto,
  docbook_xml_dtd_45,
  docbook_xsl,
  libxslt,
}:

stdenv.mkDerivation rec {
  pname = "shadowsocks-libev";
  version = "3.3.5";

  # Git tag includes CMake build files which are much more convenient.
  src = fetchFromGitHub {
    owner = "shadowsocks";
    repo = "shadowsocks-libev";
    tag = "v${version}";
    sha256 = "1iqpmhxk354db1x08axg6wrdy9p9a4mz0h9351i3mf3pqd1v6fdw";
    fetchSubmodules = true;
  };

  buildInputs = [
    libsodium
    mbedtls_2
    libev
    c-ares
    pcre
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
    "-DWITH_STATIC=OFF"
    "-DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON"
    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  postPatch = ''
    # cmake 4 compatibility
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.2)" "cmake_minimum_required(VERSION 3.10)"

    # https://github.com/shadowsocks/shadowsocks-libev/issues/2901
    substituteInPlace CMakeLists.txt \
      --replace-fail '# pkg-config' \
                '# pkg-config
                 include(GNUInstallDirs)'
    substituteInPlace cmake/shadowsocks-libev.pc.cmake \
      --replace-fail @prefix@ @CMAKE_INSTALL_PREFIX@ \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_BINDIR@ @CMAKE_INSTALL_FULL_BINDIR@ \
      --replace-fail '$'{exec_prefix}/@CMAKE_INSTALL_FULL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@ \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_DATAROOTDIR@ @CMAKE_INSTALL_FULL_DATAROOTDIR@ \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_MANDIR@ @CMAKE_INSTALL_FULL_MANDIR@

    # https://github.com/dcreager/libcork/issues/173 but needs a different patch (yay vendoring)
    substituteInPlace libcork/src/libcork.pc.in \
      --replace-fail '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  postInstall = ''
    cp lib/* $out/lib
  '';

  meta = with lib; {
    description = "Lightweight secured SOCKS5 proxy";
    longDescription = ''
      Shadowsocks-libev is a lightweight secured SOCKS5 proxy for embedded devices and low-end boxes.
      It is a port of Shadowsocks created by @clowwindy, which is maintained by @madeye and @linusyang.
    '';
    homepage = "https://github.com/shadowsocks/shadowsocks-libev";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
