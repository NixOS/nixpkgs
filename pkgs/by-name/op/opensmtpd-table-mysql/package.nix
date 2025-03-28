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
    rev = finalAttrs.version;
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

  meta = with lib; {
    homepage = "https://www.opensmtpd.org/";
    description = "ldap table for the OpenSMTPD mail server";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      pks
    ];
  };
})
