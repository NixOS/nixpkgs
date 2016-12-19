# QEMU flags shared between various Nix expressions.

{

  qemuNICFlags = nic: net: machine:
    [ "-net nic,vlan=${toString nic},macaddr=52:54:00:12:${toString net}:${toString machine},model=virtio"
      "-net vde,vlan=${toString nic},sock=$QEMU_VDE_SOCKET_${toString net}"
    ];

}
