{
  lib,
  stdenv,
  fetchurl,
  libressl,
  privsepPath ? "/var/empty",
  privsepUser ? "ntp",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openntpd";
  version = "7.9p1";

  src = fetchurl {
    url = "mirror://openbsd/OpenNTPD/openntpd-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-CR7rP041jijDqy6lj5PXoLV1iiDXyKBBjhYumywnrdw=";
  };

  postPatch = ''
    sed -i '20i#include <sys/cdefs.h>' src/ntpd.h
    sed -i '19i#include <sys/cdefs.h>' src/log.c
  '';

  configureFlags = [
    "--with-privsep-path=${privsepPath}"
    "--with-privsep-user=${privsepUser}"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-cacert=/etc/ssl/certs/ca-certificates.crt"
  ];

  buildInputs = [ libressl ];

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  meta = {
    homepage = "https://www.openntpd.org/";
    license = lib.licenses.bsd3;
    description = "OpenBSD NTP daemon (Debian port)";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ thoughtpolice ];
  };
})
