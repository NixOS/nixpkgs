{ libguestfs, libguestfs-appliance }:

libguestfs.override { appliance = libguestfs-appliance; }
