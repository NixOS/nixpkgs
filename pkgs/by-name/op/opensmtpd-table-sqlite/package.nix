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
    rev = finalAttrs.version;
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
