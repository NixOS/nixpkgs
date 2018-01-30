# QEMU flags shared between various Nix expressions.
{ pkgs }:

{

  qemuNICFlags = nic: net: machine:
    [ "-net nic,vlan=${toString nic},macaddr=52:54:00:12:${toString net}:${toString machine},model=virtio"
      "-net vde,vlan=${toString nic},sock=$QEMU_VDE_SOCKET_${toString net}"
    ];

  qemuSerialDevice = if pkgs.stdenv.isi686 || pkgs.stdenv.isx86_64 then "ttyS0"
        else if pkgs.stdenv.isArm || pkgs.stdenv.isAarch64 then "ttyAMA0"
        else throw "Unknown QEMU serial device for system '${pkgs.stdenv.system}'";

}
