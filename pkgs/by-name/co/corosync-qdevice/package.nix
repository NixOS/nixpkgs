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

stdenv.mkDerivation rec {
  pname = "corosync-qdevice";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "corosync";
    repo = "corosync-qdevice";
    rev = "v${version}";
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

  meta = with lib; {
    description = "Corosync Cluster Engine Qdevice";
    homepage = "https://github.com/corosync/corosync-qdevice";
    license = licenses.bsd3;
    maintainers = with maintainers; [ x123 ];
    #platforms = platforms.linux;
  };
}
