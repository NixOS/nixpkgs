{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "opensmtpd-table-socketmap";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "OpenSMTPD";
    repo = "table-socketmap";
    rev = finalAttrs.version;
    hash = "sha256-YTV0ijD264C7JAiB5ZfuCZhAmkLN0GSNl1vkZ3i3aRo=";
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
    description = "ldap table for the OpenSMTPD mail server";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      pks
    ];
  };
})
