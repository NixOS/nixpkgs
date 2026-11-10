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
    tag = finalAttrs.version;
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

  meta = {
    homepage = "https://www.opensmtpd.org/";
    description = "Socketmap tables the OpenSMTPD mail server";
    changelog = "https://github.com/OpenSMTPD/table-socketmap/releases/tag/${finalAttrs.version}";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      pks
    ];
  };
})
