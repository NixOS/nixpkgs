{ stdenv
, lib
, fetchurl
, pkg-config
, gtk-doc
, gobject-introspection
, gjs
, nixosTests
, pkgsCross
, curl
, glib
, systemd
, xz
, e2fsprogs
, libsoup_2_4
, glib-networking
, wrapGAppsNoGuiHook
, gpgme
, which
, makeWrapper
, autoconf
, automake
, libtool
, fuse3
, util-linuxMinimal
, libselinux
, libsodium
, libarchive
, libcap
, bzip2
, bison
, libxslt
, docbook-xsl-nons
, docbook_xml_dtd_42
, python3
}:

let
  testPython = python3.withPackages (p: with p; [
    pyyaml
  ]);
in stdenv.mkDerivation rec {
  pname = "ostree";
  version = "2024.8";

  outputs = [ "out" "dev" "man" "installedTests" ];

  src = fetchurl {
    url = "https://github.com/ostreedev/ostree/releases/download/v${version}/libostree-${version}.tar.xz";
    sha256 = "sha256-4hNuEWZp8RT/c0nxLimfY8C+znM0UWSUFKjc2FuGPD8=";
  };


  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
    gtk-doc
    gobject-introspection
    which
    makeWrapper
    bison
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_42
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    curl
    glib
    systemd
    e2fsprogs
    libsoup_2_4
    glib-networking
    gpgme
    fuse3
    libselinux
    libsodium
    libcap
    libarchive
    bzip2
    xz
    util-linuxMinimal # for libmount

    # for installed tests
    testPython
    gjs
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-curl"
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "--with-systemdsystemgeneratordir=${placeholder "out"}/lib/systemd/system-generators"
    "--enable-installed-tests"
    "--with-ed25519-libsodium"
  ];

  makeFlags = [
    "installed_testdir=${placeholder "installedTests"}/libexec/installed-tests/libostree"
    "installed_test_metadir=${placeholder "installedTests"}/share/installed-tests/libostree"
    # Setting this flag was required as workaround for a clang bug, but seems not relevant anymore.
    # https://github.com/ostreedev/ostree/commit/fd8795f3874d623db7a82bec56904648fe2c1eb7
    # See also Makefile-libostree.am
    "INTROSPECTION_SCANNER_ENV="
  ];

  preConfigure = ''
    env NOCONFIGURE=1 ./autogen.sh
  '';

  postFixup = let
    typelibPath = lib.makeSearchPath "/lib/girepository-1.0" [
      (placeholder "out")
      gobject-introspection
    ];
  in ''
    for test in $installedTests/libexec/installed-tests/libostree/*.js; do
      wrapProgram "$test" --prefix GI_TYPELIB_PATH : "${typelibPath}"
    done
  '';

  passthru = {
    tests = {
      musl = pkgsCross.musl64.ostree;
      installedTests = nixosTests.installed-tests.ostree;
    };
  };

  meta = with lib; {
    description = "Git for operating system binaries";
    homepage = "https://ostreedev.github.io/ostree/";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ copumpkin ];
  };
}
