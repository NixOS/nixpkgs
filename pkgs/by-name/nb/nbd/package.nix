{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  autoconf-archive,
  pkg-config,
  glib,
  which,
  bison,
  flex,
  docbook2x,
  docbook_sgml_dtd_41,
  docbook_sgml_dtd_45,
  nixosTests,
  libnl,
  linuxHeaders,
  gnutls,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nbd";
  version = "3.27.1";

  src = fetchFromGitHub {
    owner = "NetworkBlockDevice";
    repo = "nbd";
    tag = "nbd-${finalAttrs.version}";
    hash = "sha256-0ahoLnwLdQdpr0AuRpNoid17hXo9BWlIOWRjRwhJ/LM=";
  };

  patches = [
    # Fix nbd device parsing
    (fetchpatch {
      url = "https://github.com/NetworkBlockDevice/nbd/commit/a80304e10e9709d4100c935bc4cdc9086e86d5ff.patch";
      hash = "sha256-PMgVz2a8cwv1tO8ac5Wrf8ZFvOmCq+mC5bysJJGhpGc=";
    })
  ];

  postPatch = ''
    substituteInPlace configure.ac \
      --replace-fail "support/genver.sh" "echo ${finalAttrs.version}"
    substituteInPlace man/Makefile.am \
      --replace-fail "docbook2man" "docbook2man --sgml"
  '';

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
    bison
    flex
    docbook2x # docbook2man
  ];

  buildInputs = [
    glib
    gnutls
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libnl
    linuxHeaders
  ];

  nativeCheckInputs = [
    which
  ];

  configureFlags = [
    "--sysconfdir=/etc"
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  env.SGML_CATALOG_FILES = lib.concatStringsSep ":" [
    "${docbook_sgml_dtd_41}/sgml/dtd/docbook-4.1/docbook.cat"
    "${docbook_sgml_dtd_45}/sgml/dtd/docbook-4.5/docbook.cat"
  ];

  passthru.tests = {
    test = nixosTests.nbd;
  };

  meta = {
    homepage = "https://nbd.sourceforge.io/";
    description = "Map arbitrary files as block devices over the network";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
