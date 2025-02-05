{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  hiredis,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "opensmtpd-table-redis";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "OpenSMTPD";
    repo = "table-redis";
    rev = finalAttrs.version;
    hash = "sha256-eS/jzran7/j3xrFuEqTLam0pokD/LBl4v2s/1ferCqk=";
  };

  patches = [
    ./table-redis-hiredis-header.patch
  ];

  strictDeps = true;

  buildInputs = [
    hiredis
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
