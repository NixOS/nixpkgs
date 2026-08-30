{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "opensmtpd-table-passwd";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "OpenSMTPD";
    repo = "table-passwd";
    tag = finalAttrs.version;
    hash = "sha256-veE7PADO8KAMEnMrDc9V/xbVMqwF3rUoYPmpQSIJw9o=";
  };

  strictDeps = true;

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
    description = "Passwd tables for the OpenSMTPD mail server";
    changelog = "https://github.com/OpenSMTPD/table-passwd/releases/tag/${finalAttrs.version}";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      pks
    ];
  };
})
