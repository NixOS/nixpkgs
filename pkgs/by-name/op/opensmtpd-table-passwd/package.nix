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
    rev = finalAttrs.version;
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

  meta = with lib; {
    homepage = "https://www.opensmtpd.org/";
    description = "passwd table for the OpenSMTPD mail server";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      pks
    ];
  };
})
