{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libpq,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "opensmtpd-table-postgres";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "OpenSMTPD";
    repo = "table-postgres";
    tag = finalAttrs.version;
    hash = "sha256-CGtqCQnsUvgsBIJOVXphkisp3Iij+oW88w7Y1njusx8=";
  };

  strictDeps = true;

  buildInputs = [
    libpq
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

  meta = {
    homepage = "https://www.opensmtpd.org/";
    description = "PostgreSQL tables for the OpenSMTPD mail server";
    changelog = "https://github.com/OpenSMTPD/table-postgres/releases/tag/${finalAttrs.version}";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      pks
    ];
  };
})
