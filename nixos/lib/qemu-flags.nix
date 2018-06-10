# QEMU flags shared between various Nix expressions.
{ pkgs }:

{

  qemuNICFlags = nic: net: machine:
    [ "-net nic,vlan=${toString nic},macaddr=52:54:00:12:${toString net}:${toString machine},model=virtio"
      "-net vde,vlan=${toString nic},sock=$QEMU_VDE_SOCKET_${toString net}"
    ];

  qemuSerialDevice = if pkgs.stdenv.isi686 || pkgs.stdenv.isx86_64 then "ttyS0"
        else if pkgs.stdenv.isAarch32 || pkgs.stdenv.isAarch64 then "ttyAMA0"
        else throw "Unknown QEMU serial device for system '${pkgs.stdenv.system}'";

  qemuBinary = qemuPkg: {
    "x86_64-linux" = "${qemuPkg}/bin/qemu-kvm -cpu kvm64";
    "armv7l-linux" = "${qemuPkg}/bin/qemu-system-arm -enable-kvm -machine virt -cpu host";
    "aarch64-linux" = "${qemuPkg}/bin/qemu-system-aarch64 -enable-kvm -machine virt,gic-version=host -cpu host";
    "x86_64-darwin" = "${qemuPkg}/bin/qemu-kvm -cpu kvm64";
  }.${pkgs.stdenv.system} or "${qemuPkg}/bin/qemu-kvm";
}
