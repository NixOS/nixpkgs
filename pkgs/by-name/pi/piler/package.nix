{ lib
, stdenv
, fetchFromBitbucket
, openssl
, tre
, libzip
, libmysqlclient
, which
, php
}:

stdenv.mkDerivation rec {
  pname = "piler";
  version = "1.4.3";

  src = fetchFromBitbucket {
    owner = "jsuto";
    repo = "piler";
    rev = "refs/tags/piler-${version}";
    hash = "sha256-Ul/OH9r/+255b23gti5dCN8irHW1E+BpX7pEw65hC/c=";
  };

  postPatch = ''
    # Patching Makefiles to avoid changing ownership of installed files
    substituteInPlace Makefile.in \
      --replace "-o \$(RUNNING_USER) -g \$(RUNNING_GROUP) " ""
    substituteInPlace src/Makefile.in \
      --replace "-o \$(RUNNING_USER) -g \$(RUNNING_GROUP) " ""
    substituteInPlace src/Makefile.in \
      --replace "-m 6755" ""
    substituteInPlace etc/Makefile.in \
      --replace "-g \$(RUNNING_GROUP) " ""
    substituteInPlace util/Makefile.in \
      --replace "-o \$(RUNNING_USER) -g \$(RUNNING_GROUP) " ""

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
      --replace "/etc/piler" "$out/etc/piler"
    mv $out/etc/piler/config-site.dist.php $out/etc/piler/config-site.php

    # FIXME
    substituteInPlace $out/libexec/piler/postinstall.sh \
      --replace "DATAROOTDIR=/share" "DATAROOTDIR=$out/share" \
      --replace "SYSCONFDIR=/etc" "SYSCONFDIR=$out/etc" \
      --replace "PILER_CONFIG_DIR=\"$\{SYSCONFDIR\}/piler\"" 'PILER_CONFIG_DIR="/var/lib/piler"'

    substituteInPlace $out/etc/piler/manticore.conf.dist \
      --replace "'/var'" "'/var/lib'" \
      --replace "/var/piler" "/var/lib/piler"
  '';

  meta = with lib; {
    homepage = "https://www.mailpiler.org";
    description = "Open source email archiving solution";
    platforms = platforms.unix;
    license = licenses.gpl3;
    maintainers = with maintainers; [ onny ];
  };
}
