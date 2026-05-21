{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  pkg-config,
  ninja,
  perl,
  util-linux,
  open-isns,
  openssl,
  kmod,
  systemd,
  runtimeShell,
  nixosTests,
  udevCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "open-iscsi";
  version = "2.1.11";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "open-iscsi";
    rev = finalAttrs.version;
    hash = "sha256-Xs2EiNSkRtAQPoagCAKl07VndYKDspGLchxMvsfvTi0=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    perl
    udevCheckHook
  ];
  buildInputs = [
    kmod
    open-isns
    openssl
    systemd
    util-linux
  ];

  preConfigure = ''
    patchShebangs .
  '';

  prePatch = ''
    substituteInPlace etc/systemd/iscsi-init.service.template \
      --replace /usr/bin/sh ${runtimeShell}
    sed -i '/install_dir: db_root/d' meson.build
  '';

  mesonFlags = [
    "-Discsi_sbindir=${placeholder "out"}/sbin"
    "-Drulesdir=${placeholder "out"}/etc/udev/rules.d"
    "-Dsystemddir=${placeholder "out"}/lib/systemd"
    "-Ddbroot=/etc/iscsi"
  ];

  doInstallCheck = true;

  passthru.tests = { inherit (nixosTests) iscsi-root; };

  meta = {
    description = "High performance, transport independent, multi-platform implementation of RFC3720";
    license = lib.licenses.gpl2Plus;
    homepage = "https://www.open-iscsi.com";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      cleverca22
      zaninime
    ];
  };
})
