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

stdenv.mkDerivation rec {
  pname = "alpine";
  version = "2.26";

  src = fetchgit {
    url = "https://repo.or.cz/alpine.git";
    rev = "v${version}";
    hash = "sha256-cJyUBatQBjD6RG+jesJ0JRhWghPRBACc/HQl+2aCTd0=";
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
}
