{
  lib,
  stdenv,
  fetchFromGitHub,
  nixosTests,
  autoreconfHook,
  bison,
  flex,
  docbook_xml_dtd_45,
  docbook_xsl,
  itstool,
  libxml2,
  libxslt,
  libxcrypt,
  pkg-config,
  glibc ? null,
  pam ? null,
  withLibbsd ? lib.meta.availableOn stdenv.hostPlatform libbsd,
  libbsd,
  withTcb ? lib.meta.availableOn stdenv.hostPlatform tcb,
  tcb,
}:
let
  glibc' =
    if stdenv.hostPlatform != stdenv.buildPlatform then
      glibc
    else
      assert stdenv.hostPlatform.libc == "glibc";
      stdenv.cc.libc;

in

stdenv.mkDerivation rec {
  pname = "shadow";
  version = "4.18.0";

  src = fetchFromGitHub {
    owner = "shadow-maint";
    repo = "shadow";
    rev = version;
    hash = "sha256-M7We3JboNpr9H0ELbKcFtMvfmmVYaX9dYcsQ3sVX0lM=";
  };

  outputs = [
    "out"
    "su"
    "dev"
    "man"
  ];

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    docbook_xml_dtd_45
    docbook_xsl
    itstool
    libxml2
    libxslt
    pkg-config
  ];

  buildInputs = [
    libxcrypt
  ]
  ++ lib.optional (pam != null && (lib.meta.availableOn stdenv.hostPlatform pam)) pam
  ++ lib.optional withLibbsd libbsd
  ++ lib.optional withTcb tcb;

  patches = [
    ./keep-path.patch
    # Obtain XML resources from XML catalog (patch adapted from gtk-doc)
    ./respect-xml-catalog-files-var.patch
    ./fix-install-with-tcb.patch
  ];

  postPatch = ''
    # The nix daemon often forbids even creating set[ug]id files
    sed 's/^\(s[ug]idperms\) = [0-9]755/\1 = 0755/' -i src/Makefile.am

    # The default shell is not defined at build time of the package. It is
    # decided at build time of the NixOS configration. Thus, don't decide this
    # here but just point to the location of the shell on the system.
    substituteInPlace configure.ac --replace-fail '$SHELL' /bin/sh
  '';

  # `AC_FUNC_SETPGRP' is not cross-compilation capable.
  preConfigure = ''
    export ac_cv_func_setpgrp_void=${if stdenv.hostPlatform.isBSD then "no" else "yes"}
    export shadow_cv_logdir=/var/log
  '';

  configureFlags = [
    "--enable-man"
    "--with-group-name-max-length=32"
    "--with-bcrypt"
    "--with-yescrypt"
    (lib.withFeature withLibbsd "libbsd")
  ]
  ++ lib.optional (stdenv.hostPlatform.libc != "glibc") "--disable-nscd"
  ++ lib.optional withTcb "--with-tcb";

  preBuild = lib.optionalString (stdenv.hostPlatform.libc == "glibc") ''
    substituteInPlace lib/nscd.c --replace /usr/sbin/nscd ${glibc'.bin}/bin/nscd
  '';

  postInstall = ''
    # Move the su binary into the su package
    mkdir -p $su/bin
    mv $out/bin/su $su/bin
  '';

  enableParallelBuilding = true;

  disallowedReferences = lib.optional (
    stdenv.buildPlatform != stdenv.hostPlatform
  ) stdenv.shellPackage;

  meta = with lib; {
    homepage = "https://github.com/shadow-maint/shadow";
    description = "Suite containing authentication-related tools such as passwd and su";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };

  passthru = {
    shellPath = "/bin/nologin";
    tests = { inherit (nixosTests) shadow; };
  };
}
