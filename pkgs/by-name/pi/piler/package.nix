{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  tre,
  libzip,
  libmysqlclient,
  which,
  php,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "piler";
  version = "1.4.9";

  src = fetchFromGitHub {
    owner = "jsuto";
    repo = "piler";
    rev = "refs/tags/piler-${finalAttrs.version}";
    hash = "sha256-//ImnOZoa7M1kI5BsoUuXIz34IBYsQus4L9VWWZuCZg=";
  };

  postPatch = ''
    # Patching Makefiles to avoid changing ownership of installed files
    substituteInPlace Makefile.in \
      --replace-fail "-o \$(RUNNING_USER) -g \$(RUNNING_GROUP) " ""
    substituteInPlace src/Makefile.in \
      --replace-fail "-o \$(RUNNING_USER) -g \$(RUNNING_GROUP) " ""
    substituteInPlace src/Makefile.in \
      --replace-fail "-m 6755" ""
    substituteInPlace etc/Makefile.in \
      --replace-fail "-g \$(RUNNING_GROUP) " ""
    substituteInPlace util/Makefile.in \
      --replace-fail "-o \$(RUNNING_USER) -g \$(RUNNING_GROUP) " ""

    patchShebangs .
  '';

  nativeBuildInputs = [ which ];

  buildInputs = [
    libmysqlclient
    libzip
    openssl
    tre
    php
  ];

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "sbindir=/bin"
    "bindir=/bin"
    "sysconfdir=/etc"
    "libdir=/lib"
    "libexecdir=/libexec"
    "datarootdir=/share"
    "localstatedir=/var"
  ];

  configureFlags = [
    "--with-database=mysql"
    "--with-piler-user=root"
  ];

  postFixup = ''
    substituteInPlace $out/var/piler/www/config.php \
      --replace-fail "/etc/piler" "$out/etc/piler"
    mv $out/etc/piler/config-site.dist.php $out/etc/piler/config-site.php

    # FIXME
    substituteInPlace $out/libexec/piler/postinstall.sh \
      --replace "DATAROOTDIR=/share" "DATAROOTDIR=$out/share" \
      --replace "SYSCONFDIR=/etc" "SYSCONFDIR=$out/etc" \
      --replace "PILER_CONFIG_DIR=\"$\{SYSCONFDIR\}/piler\"" 'PILER_CONFIG_DIR="/var/lib/piler"'

    substituteInPlace $out/etc/piler/manticore.conf.dist \
      --replace-fail "'/var'" "'/var/lib'" \
      --replace-fail "/var/piler" "/var/lib/piler"
  '';

  passthru.nixosTests.piler = nixosTests.piler;

  meta = {
    homepage = "https://www.mailpiler.org";
    description = "Open source email archiving solution";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.onny ];
  };
})
