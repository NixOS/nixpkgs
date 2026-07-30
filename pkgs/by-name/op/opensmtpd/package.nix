{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  autoconf-archive,
  pkgconf,
  libtool,
  bison,
  libevent,
  zlib,
  libressl,
  db,
  pam,
  libxcrypt,
  nixosTests,
  binPath ? "/run/wrappers/bin",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opensmtpd";
  version = "7.8.0p0";

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkgconf
    libtool
    bison
  ];
  buildInputs = [
    libevent
    zlib
    libressl
    db
    pam
    libxcrypt
  ];

  src = fetchurl {
    url = "https://www.opensmtpd.org/archives/opensmtpd-${finalAttrs.version}.tar.gz";
    hash = "sha256-QDTeLpLGH6g+7a2x2Ni9/mXlfrUM6WeeAUCVDjTKSrc=";
  };

  patches = [
    ./proc_path.diff # TODO: upstream to OpenSMTPD, see https://github.com/NixOS/nixpkgs/issues/54045
    ./offline.patch
  ];

  postPatch = ''
    substituteInPlace mk/smtpctl/Makefile.am \
      --replace-fail "chgrp" "true" \
      --replace "chmod 2555" "chmod 0555"
    substituteInPlace mk/pathnames \
      --replace-fail "-DPATH_SMTPCTL=\\\"\$(sbindir)" \
                     "-DPATH_SMTPCTL=\\\"${binPath}" \
      --replace-fail "-DPATH_MAKEMAP=\\\"\$(sbindir)" \
                     "-DPATH_MAKEMAP=\\\"${binPath}"
    substituteInPlace usr.sbin/smtpd/smtpd.c \
      --replace-fail "@@PATH_SENDMAIL@@" "\"${binPath}/sendmail\""
  '';

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-mantype=doc"
    "--with-auth-pam"
    "--without-auth-bsdauth"
    "--with-path-socket=/run"
    "--with-path-pidfile=/run"
    "--with-user-smtpd=smtpd"
    "--with-user-queue=smtpq"
    "--with-group-queue=smtpq"
    "--with-path-CAfile=/etc/ssl/certs/ca-certificates.crt"
    "--with-libevent=${libevent.dev}"
    "--with-table-db"
  ];

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  meta = {
    homepage = "https://www.opensmtpd.org/";
    description = ''
      A free implementation of the server-side SMTP protocol as defined by
      RFC 5321, with some additional standard extensions
    '';
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      obadz
      vifino
    ];
  };
  passthru.tests = {
    basic-functionality-and-dovecot-interaction = nixosTests.opensmtpd;
    rspamd-integration = nixosTests.opensmtpd-rspamd;
  };
})
