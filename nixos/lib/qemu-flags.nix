# QEMU flags shared between various Nix expressions.
{ pkgs }:

let
  zeroPad = n:
    pkgs.lib.optionalString (n < 16) "0" +
      (if n > 255
       then throw "Can't have more than 255 nets or nodes!"
       else pkgs.lib.toHexString n);
in

rec {
  qemuNicMac = net: machine: "52:54:00:12:${zeroPad net}:${zeroPad machine}";

  qemuNICFlags = nic: net: machine:
    [ "-device virtio-net-pci,netdev=vlan${toString nic},mac=${qemuNicMac net machine}"
      "-netdev vde,id=vlan${toString nic},sock=$QEMU_VDE_SOCKET_${toString net}"
    ];

  qemuSerialDevice = if pkgs.stdenv.isi686 || pkgs.stdenv.isx86_64 then "ttyS0"
        else if pkgs.stdenv.isAarch32 || pkgs.stdenv.isAarch64 then "ttyAMA0"
        else throw "Unknown QEMU serial device for system '${pkgs.stdenv.hostPlatform.system}'";

  qemuBinary = qemuPkg: {
    x86_64-linux = "${qemuPkg}/bin/qemu-kvm -cpu host";
    armv7l-linux = "${qemuPkg}/bin/qemu-system-arm -enable-kvm -machine virt -cpu host";
    aarch64-linux = "${qemuPkg}/bin/qemu-system-aarch64 -enable-kvm -machine virt,gic-version=host -cpu host";
    x86_64-darwin = "${qemuPkg}/bin/qemu-kvm -cpu host";
  }.${pkgs.stdenv.hostPlatform.system} or "${qemuPkg}/bin/qemu-kvm";
}
