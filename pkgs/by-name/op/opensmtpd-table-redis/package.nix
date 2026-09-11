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
    tag = finalAttrs.version;
    hash = "sha256-eS/jzran7/j3xrFuEqTLam0pokD/LBl4v2s/1ferCqk=";
  };

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

  env.NIX_CFLAGS_COMPILE = "-I${hiredis}/include/hiredis";

  preConfigure = ''
    sh bootstrap
  '';

  meta = {
    homepage = "https://www.opensmtpd.org/";
    description = "Redis tables for the OpenSMTPD mail server";
    changelog = "https://github.com/OpenSMTPD/table-redis/releases/tag/${finalAttrs.version}";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      pks
    ];
  };
})
