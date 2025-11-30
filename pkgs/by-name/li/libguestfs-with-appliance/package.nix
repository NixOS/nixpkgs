{
  libguestfs,
  libguestfs-appliance-nixos,
}:

libguestfs.override { appliance = libguestfs-appliance-nixos; }
