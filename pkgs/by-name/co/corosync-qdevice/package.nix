{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  corosync,
  libqb,
  nss,
  nspr,
  systemd,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "corosync-qdevice";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "corosync";
    repo = "corosync-qdevice";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JJYD1owtTtXW2yTZNhponzd6Sbj6zjfhein20m/7DQw=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    corosync
    libqb
    nss
    nspr
    systemd
  ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--enable-systemd"
  ];

  installFlags = [
    "sysconfdir=$(out)/etc"
    "localstatedir=$(out)/var"
    "COROSYSCONFDIR=$(out)/etc/corosync"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/corosync-qnetd";
  versionCheckProgramArg = "-v";
  doInstallCheck = true;

  meta = {
    description = "Corosync Cluster Engine Qdevice";
    homepage = "https://github.com/corosync/corosync-qdevice";
    changelog = "https://github.com/corosync/corosync-qdevice/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ x123 ];
    mainProgram = "corosync-qdevice";
    platforms = lib.platforms.linux;
  };
})
