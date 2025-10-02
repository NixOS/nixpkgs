{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  sqlite,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "opensmtpd-table-sqlite";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "OpenSMTPD";
    repo = "table-sqlite";
    tag = finalAttrs.version;
    hash = "sha256-Y5AveTo+Ol6cMcxOW3/GMZZD+17HiQdQ4Vg5WHPjKgA=";
  };

  strictDeps = true;

  buildInputs = [
    sqlite
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
    description = "SQLite tables for the OpenSMTPD mail server";
    changelog = "https://github.com/OpenSMTPD/table-sqlite/releases/tag/${finalAttrs.version}";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      pks
    ];
  };
})
