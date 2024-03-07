{ lib
, incus-unwrapped
, linkFarm
, makeWrapper
, stdenv
, symlinkJoin
, writeShellScriptBin
, acl
, apparmor-parser
, apparmor-profiles
, attr
, bash
, btrfs-progs
, criu
, dnsmasq
, gnutar
, gptfdisk
, gzip
, iproute2
, iptables
, OVMF
, qemu_kvm
, qemu-utils
, rsync
, spice-gtk
, squashfsTools
, util-linux
, virtiofsd
, xz
}:
let
  binPath = lib.makeBinPath [
    acl
    attr
    bash
    btrfs-progs
    criu
    dnsmasq
    gnutar
    gptfdisk
    gzip
    iproute2
    iptables
    qemu_kvm
    qemu-utils
    rsync
    squashfsTools
    util-linux
    virtiofsd
    xz

    (writeShellScriptBin "apparmor_parser" ''
      exec '${apparmor-parser}/bin/apparmor_parser' -I '${apparmor-profiles}/etc/apparmor.d' "$@"
    '')
  ];

  clientBinPath = [
    spice-gtk
  ];

  ovmf-2mb = OVMF.override {
    secureBoot = true;
    csmSupport = false;
    fdSize2MB = true;
  };

  ovmf-4mb = OVMF.override {
    secureBoot = true;
    csmSupport = false;
    fdSize4MB = true;
  };

  ovmf-4mb-csm = OVMF.override {
    secureBoot = true;
    csmSupport = false;
    fdSize2MB = false;
    fdSize4MB = true;
  };

  ovmf-prefix = if stdenv.hostPlatform.isAarch64 then "AAVMF" else "OVMF";

  # mimic ovmf from https://github.com/canonical/incus-pkg-snap/blob/3abebe1dfeb20f9b7729556960c7e9fe6ad5e17c/snapcraft.yaml#L378
  # also found in /snap/incus/current/share/qemu/ on a snap install
  ovmf = linkFarm "incus-ovmf" [
    { name = "OVMF_CODE.2MB.fd"; path = "${ovmf-2mb.fd}/FV/${ovmf-prefix}_CODE.fd"; }
    { name = "OVMF_CODE.4MB.CSM.fd"; path = "${ovmf-4mb-csm.fd}/FV/${ovmf-prefix}_CODE.fd"; }
    { name = "OVMF_CODE.4MB.fd"; path = "${ovmf-4mb.fd}/FV/${ovmf-prefix}_CODE.fd"; }
    { name = "OVMF_CODE.fd"; path = "${ovmf-2mb.fd}/FV/${ovmf-prefix}_CODE.fd"; }

    { name = "OVMF_VARS.2MB.fd"; path = "${ovmf-2mb.fd}/FV/${ovmf-prefix}_VARS.fd"; }
    { name = "OVMF_VARS.2MB.ms.fd"; path = "${ovmf-2mb.fd}/FV/${ovmf-prefix}_VARS.fd"; }
    { name = "OVMF_VARS.4MB.CSM.fd"; path = "${ovmf-4mb-csm.fd}/FV/${ovmf-prefix}_VARS.fd"; }
    { name = "OVMF_VARS.4MB.fd"; path = "${ovmf-4mb.fd}/FV/${ovmf-prefix}_VARS.fd"; }
    { name = "OVMF_VARS.4MB.ms.fd"; path = "${ovmf-4mb.fd}/FV/${ovmf-prefix}_VARS.fd"; }
    { name = "OVMF_VARS.fd"; path = "${ovmf-2mb.fd}/FV/${ovmf-prefix}_VARS.fd"; }
    { name = "OVMF_VARS.ms.fd"; path = "${ovmf-2mb.fd}/FV/${ovmf-prefix}_VARS.fd"; }
  ];
in
symlinkJoin {
  name = "incus-${incus-unwrapped.version}";

  paths = [ incus-unwrapped ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/incusd --prefix PATH : ${lib.escapeShellArg binPath}:${qemu_kvm}/libexec:$out/bin --set INCUS_OVMF_PATH ${ovmf}

    wrapProgram $out/bin/incus --prefix PATH : ${lib.makeBinPath clientBinPath}
  '';

  passthru = {
    inherit (incus-unwrapped) tests;
  };

  inherit (incus-unwrapped) meta pname version;
}
