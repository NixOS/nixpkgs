{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  postgresql,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "opensmtpd-table-postgres";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "OpenSMTPD";
    repo = "table-postgres";
    rev = finalAttrs.version;
    hash = "sha256-CGtqCQnsUvgsBIJOVXphkisp3Iij+oW88w7Y1njusx8=";
  };

  strictDeps = true;

  buildInputs = [
    postgresql
  ];

  nativeBuildInputs = [
    autoconf
    automake
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
