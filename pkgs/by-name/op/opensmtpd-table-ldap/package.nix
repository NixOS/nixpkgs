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
    rev = finalAttrs.version;
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
