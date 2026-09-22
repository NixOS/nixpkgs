{
  lib,
  stdenv,
  fetchurl,
  glib,
  libselinux,
  libsepol,
  nix-update-script,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "restorecond";
  # Note: The version here should be kept in sync with `libselinux` and `libsepol`
  version = "3.11";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "${libsepol.se_url}/${finalAttrs.version}/restorecond-${finalAttrs.version}.tar.gz";
    hash = "sha256-9AzlJG1CdGsi2+NjxDxuvSjQUbVo5MBtLewcS4qHpco=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libselinux
    glib
    libsepol
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "SBINDIR=$(out)/bin"
    "ETCDIR=$(out)/etc"
    "INITDIR=$(out)/etc/rc.d/init.d"
    "SELINUXDIR=$(out)/etc/selinux"
    "AUTOSTARTDIR=$(out)/etc/xdg/autostart"
    "LOCALEDIR=$(out)/share/locale"
    "MAN5DIR=$(out)/share/man/man5"
    "SYSTEMDSYSTEMUNITDIR=$(out)/lib/systemd/system"
    "SYSTEMDUSERUNITDIR=$(out)/lib/systemd/user"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^([0-9\\.]+)$"
    ];
  };

  postFixup = ''
    substituteInPlace $out/lib/systemd/*/* \
      --replace-warn /usr/sbin $out/bin
  '';

  meta = {
    description = "SELinux automatic relabeling daemon";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
    mainProgram = "restorecond";
    maintainers = with lib.maintainers; [
      naxdy
      RossComputerGuy
    ];
  };
})
