{ stdenv
, lib
, fetchurl
, fetchpatch
, pkg-config
, gtk-doc
, nixosTests
, pkgsCross
, curl
, glib
, xz
, e2fsprogs
, libsoup_2_4
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
, buildPackages
, withComposefs ? false
, composefs
, withGjs ? lib.meta.availableOn stdenv.hostPlatform gjs
, gjs
, withGlibNetworking ? lib.meta.availableOn stdenv.hostPlatform glib-networking
, glib-networking
, withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages
, gobject-introspection
, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd
, systemd
}:

let
  testPython = python3.withPackages (p: with p; [
    pyyaml
  ]);
in stdenv.mkDerivation rec {
  pname = "ostree";
  version = "2024.10";

  outputs = [ "out" "dev" "man" "installedTests" ];

  src = fetchurl {
    url = "https://github.com/ostreedev/ostree/releases/download/v${version}/libostree-${version}.tar.xz";
    sha256 = "sha256-VOM4fe4f8WAxoGeayitg2pCrf0omwhGCIzPH8jAAq+4=";
  };

  patches = [
    (fetchpatch {
      name = "static-pkg-config.patch";
      url = "https://github.com/ostreedev/ostree/pull/3382.patch";
      hash = "sha256-VCQLq4OqmojtB7WFHNNV82asgXPGq5tKoJun66eUntY=";
    })
  ];

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
    glib
    gtk-doc
    which
    makeWrapper
    bison
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_42
    wrapGAppsNoGuiHook
  ] ++ lib.optionals withIntrospection [
    gobject-introspection
  ];

  buildInputs = [
    curl
    glib
    e2fsprogs
    libsoup_2_4
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
  ] ++ lib.optionals withComposefs [
    (lib.getDev composefs)
  ] ++ lib.optionals withGjs [
    gjs
  ] ++ lib.optionals withGlibNetworking [
    glib-networking
  ] ++ lib.optionals withSystemd [
    systemd
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-curl"
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "--with-systemdsystemgeneratordir=${placeholder "out"}/lib/systemd/system-generators"
    "--enable-installed-tests"
    "--with-ed25519-libsodium"
  ] ++ lib.optionals withComposefs [
    "--with-composefs"
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
  in lib.optionalString withIntrospection ''
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
