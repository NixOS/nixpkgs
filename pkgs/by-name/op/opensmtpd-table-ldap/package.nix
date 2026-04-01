{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libevent,
  libressl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "opensmtpd-table-ldap";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "OpenSMTPD";
    repo = "table-ldap";
    tag = finalAttrs.version;
    hash = "sha256-dfwvgFYBED3GyZ347JSNIyiik133GYLT6p+XkIIm//w=";
  };

  strictDeps = true;

  buildInputs = [
    libevent
    libressl
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
    description = "LDAP tables for the OpenSMTPD mail server";
    changelog = "https://github.com/OpenSMTPD/table-ldap/releases/tag/${finalAttrs.version}";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      pks
    ];
  };
})
