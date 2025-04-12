{
  lib,
  lxd-unwrapped-lts,
  linkFarm,
  makeWrapper,
  stdenv,
  symlinkJoin,
  writeShellScriptBin,
  acl,
  apparmor-parser,
  apparmor-profiles,
  attr,
  bash,
  btrfs-progs,
  cdrkit,
  criu,
  dnsmasq,
  e2fsprogs,
  getent,
  gnutar,
  gptfdisk,
  gzip,
  iproute2,
  iptables,
  kmod,
  lvm2,
  minio,
  nftables,
  OVMF,
  qemu_kvm,
  qemu-utils,
  rsync,
  spice-gtk,
  squashfsTools,
  thin-provisioning-tools,
  util-linux,
  virtiofsd,
  xz,
}:
let
  binPath = lib.makeBinPath [
    acl
    attr
    bash
    btrfs-progs
    cdrkit
    criu
    dnsmasq
    e2fsprogs
    getent
    gnutar
    gptfdisk
    gzip
    iproute2
    iptables
    kmod
    lvm2
    minio
    nftables
    qemu_kvm
    qemu-utils
    rsync
    squashfsTools
    thin-provisioning-tools
    util-linux
    virtiofsd
    xz

    (writeShellScriptBin "apparmor_parser" ''
      exec '${apparmor-parser}/bin/apparmor_parser' -I '${apparmor-profiles}/etc/apparmor.d' "$@"
    '')
  ];

  clientBinPath = [ spice-gtk ];

  ovmf-2mb = OVMF.override {
    secureBoot = true;
    fdSize2MB = true;
  };

  ovmf-4mb = OVMF.override {
    secureBoot = true;
    fdSize4MB = true;
  };

  ovmf-prefix = if stdenv.hostPlatform.isAarch64 then "AAVMF" else "OVMF";

  # mimic ovmf from https://github.com/canonical/lxd-pkg-snap/blob/3abebe1dfeb20f9b7729556960c7e9fe6ad5e17c/snapcraft.yaml#L378
  # also found in /snap/lxd/current/share/qemu/ on a snap install
  ovmf = linkFarm "lxd-ovmf" [
    {
      name = "OVMF_CODE.2MB.fd";
      path = "${ovmf-2mb.fd}/FV/${ovmf-prefix}_CODE.fd";
    }
    {
      name = "OVMF_CODE.4MB.fd";
      path = "${ovmf-4mb.fd}/FV/${ovmf-prefix}_CODE.fd";
    }
    {
      name = "OVMF_CODE.fd";
      path = "${ovmf-2mb.fd}/FV/${ovmf-prefix}_CODE.fd";
    }

    {
      name = "OVMF_VARS.2MB.fd";
      path = "${ovmf-2mb.fd}/FV/${ovmf-prefix}_VARS.fd";
    }
    {
      name = "OVMF_VARS.2MB.ms.fd";
      path = "${ovmf-2mb.fd}/FV/${ovmf-prefix}_VARS.fd";
    }
    {
      name = "OVMF_VARS.4MB.fd";
      path = "${ovmf-4mb.fd}/FV/${ovmf-prefix}_VARS.fd";
    }
    {
      name = "OVMF_VARS.4MB.ms.fd";
      path = "${ovmf-4mb.fd}/FV/${ovmf-prefix}_VARS.fd";
    }
    {
      name = "OVMF_VARS.fd";
      path = "${ovmf-2mb.fd}/FV/${ovmf-prefix}_VARS.fd";
    }
    {
      name = "OVMF_VARS.ms.fd";
      path = "${ovmf-2mb.fd}/FV/${ovmf-prefix}_VARS.fd";
    }
  ];
in
symlinkJoin {
  name = "lxd-${lxd-unwrapped-lts.version}";

  paths = [ lxd-unwrapped-lts ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/lxd --prefix PATH : ${lib.escapeShellArg binPath}:${qemu_kvm}/libexec:$out/bin --set LXD_OVMF_PATH ${ovmf}

    wrapProgram $out/bin/lxc --prefix PATH : ${lib.makeBinPath clientBinPath}
  '';

  passthru = {
    inherit (lxd-unwrapped-lts) tests;
  };

  inherit (lxd-unwrapped-lts) meta pname version;
}
