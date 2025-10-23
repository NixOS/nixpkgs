{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libmysqlclient,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "opensmtpd-table-mysql";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "OpenSMTPD";
    repo = "table-mysql";
    tag = finalAttrs.version;
    hash = "sha256-0N1fuYJvJKAoOJMH2bX0pdvAqb26w/6JSuv6ycnRZHU=";
  };

  strictDeps = true;

  buildInputs = [
    libmysqlclient
  ];

  nativeBuildInputs = [
    autoconf
    automake
    libmysqlclient
  ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-path-socket=/run"
    "--with-path-pidfile=/run"
  ];

  preConfigure = ''
    sh bootstrap
  '';

  meta = {
    homepage = "https://www.opensmtpd.org/";
    description = "MySQL or MariaDB tables for the OpenSMTPD mail server";
    changelog = "https://github.com/OpenSMTPD/table-mysql/releases/tag/${finalAttrs.version}";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      pks
    ];
  };
})
