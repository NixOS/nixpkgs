{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  gtk-doc,
  nixosTests,
  pkgsCross,
  curl,
  glib,
  xz,
  e2fsprogs,
  libsoup_3,
  gpgme,
  which,
  makeWrapper,
  autoconf,
  automake,
  libtool,
  fuse3,
  util-linuxMinimal,
  libselinux,
  libsodium,
  libarchive,
  libcap,
  bzip2,
  bison,
  libxslt,
  docbook-xsl-nons,
  docbook_xml_dtd_42,
  python3,
  buildPackages,
  withComposefs ? false,
  composefs,
  withGjs ? lib.meta.availableOn stdenv.hostPlatform gjs,
  gjs,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  gobject-introspection,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  systemd,
  replaceVars,
  openssl,
  ostree-full,
  testers,
}:

let
  testPython = python3.withPackages (
    p: with p; [
      pyyaml
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ostree";
  version = "2025.7";

  outputs = [
    "out"
    "dev"
    "man"
    "installedTests"
  ];

  src = fetchurl {
    url = "https://github.com/ostreedev/ostree/releases/download/v${finalAttrs.version}/libostree-${finalAttrs.version}.tar.xz";
    hash = "sha256-r40IC5WF5/0fq6jwIpZ+HCaK5i4g7PMu57NkweMHVws=";
  };

  patches = [
    # Workarounds for installed tests failing in pseudoterminal
    # https://github.com/ostreedev/ostree/issues/1592
    ./fix-1592.patch

    # Hard-code paths in installed tests
    (replaceVars ./fix-test-paths.patch {
      python3 = testPython.interpreter;
      openssl = "${openssl}/bin/openssl";
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
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
  ];

  buildInputs = [
    curl
    glib
    e2fsprogs
    libsoup_3 # for trivial-httpd for tests
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
  ]
  ++ lib.optionals withComposefs [
    (lib.getDev composefs)
  ]
  ++ lib.optionals withGjs [
    gjs
  ]
  ++ lib.optionals withSystemd [
    systemd
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-curl"
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "--with-systemdsystemgeneratordir=${placeholder "out"}/lib/systemd/system-generators"
    "--enable-installed-tests"
    "--with-ed25519-libsodium"
  ]
  ++ lib.optionals withComposefs [
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

  postFixup =
    let
      typelibPath = lib.makeSearchPath "/lib/girepository-1.0" [
        (placeholder "out")
        glib.out
      ];
    in
    lib.optionalString withIntrospection ''
      for test in $installedTests/libexec/installed-tests/libostree/*.js; do
        wrapProgram "$test" --prefix GI_TYPELIB_PATH : "${typelibPath}"
      done
    '';

  passthru = {
    tests = {
      musl = pkgsCross.musl64.ostree;
      installedTests = nixosTests.installed-tests.ostree;
      inherit ostree-full;
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
      };
    };
  };

  meta = {
    description = "Git for operating system binaries";
    homepage = "https://ostreedev.github.io/ostree/";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    pkgConfigModules = [ "ostree-1" ];
  };
})
