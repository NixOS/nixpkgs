# QEMU flags shared between various Nix expressions.

{

  qemuNICFlags = nic: net:
    "-net nic,vlan=${toString nic},model=virtio " +
    # Use 232.0.1.<vlan> as the multicast address to connect VMs on
    # the same vlan, but allow it to be overriden using the
    # $QEMU_MCAST_ADDR_<vlan> environment variable.  The test driver
    # sets this variable to prevent collisions between parallel
    # builds.
    "-net socket,vlan=${toString nic},mcast=" +
    "\${QEMU_MCAST_ADDR_${toString net}:-232.0.1.${toString net}:1234} ";
    
}
