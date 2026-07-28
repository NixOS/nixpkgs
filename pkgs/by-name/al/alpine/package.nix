{
  lib,
  stdenv,
  fetchgit,
  buildPackages,
  ncurses,
  tcl,
  openssl,
  pam,
  libkrb5,
  openldap,
  libxcrypt,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "alpine";
  version = "2.29.9";

  src = fetchgit {
    url = "https://repo.or.cz/alpine.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uAPQlF2IQPSZ0QoK9bwh6RBGsb1X0ktP1eVhs3RO44I=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  buildInputs = [
    ncurses
    tcl
    openssl
    pam
    libkrb5
    openldap
    libxcrypt
  ];

  hardeningDisable = [ "format" ];

  configureFlags = [
    "--with-ssl-include-dir=${openssl.dev}/include/openssl"
    "--with-passfile=.pine-passfile"
    "--with-c-client-target=slx"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Fixes https://github.com/NixOS/nixpkgs/issues/372699
    # See also https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1074804
    "-Wno-incompatible-pointer-types"
    # Opt out of C23 (and its stricter prototype rules) in GCC15
    "-std=gnu17"
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Console mail reader";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      raskin
      rhendric
    ];
    platforms = lib.platforms.linux;
    homepage = "https://alpineapp.email/";
  };
})
