# QEMU-related utilities shared between various Nix expressions.
{ lib, pkgs }:

let
  zeroPad = n:
    lib.optionalString (n < 16) "0" +
    (if n > 255
    then throw "Can't have more than 255 nets or nodes!"
    else lib.toHexString n);
in

rec {
  qemuNicMac = net: machine: "52:54:00:12:${zeroPad net}:${zeroPad machine}";

  qemuNICFlags = nic: net: machine:
    [
      "-device virtio-net-pci,netdev=vlan${toString nic},mac=${qemuNicMac net machine}"
      ''-netdev vde,id=vlan${toString nic},sock="$QEMU_VDE_SOCKET_${toString net}"''
    ];

  qemuSerialDevice =
    if pkgs.stdenv.hostPlatform.isx86 || pkgs.stdenv.hostPlatform.isRiscV then "ttyS0"
    else if (with pkgs.stdenv.hostPlatform; isAarch || isPower) then "ttyAMA0"
    else throw "Unknown QEMU serial device for system '${pkgs.stdenv.hostPlatform.system}'";

  qemuBinary = qemuPkg: {
    x86_64-linux = "${qemuPkg}/bin/qemu-kvm -cpu max";
    armv7l-linux = "${qemuPkg}/bin/qemu-system-arm -machine virt,accel=kvm:tcg -cpu max";
    aarch64-linux = "${qemuPkg}/bin/qemu-system-aarch64 -machine virt,gic-version=max,accel=kvm:tcg -cpu max";
    powerpc64le-linux = "${qemuPkg}/bin/qemu-system-ppc64 -machine powernv";
    powerpc64-linux = "${qemuPkg}/bin/qemu-system-ppc64 -machine powernv";
    x86_64-darwin = "${qemuPkg}/bin/qemu-kvm -cpu max";
  }.${pkgs.stdenv.hostPlatform.system} or "${qemuPkg}/bin/qemu-kvm";
}
