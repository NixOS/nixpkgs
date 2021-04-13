{

  imports = [ ./amazon-image.nix ];
  # ec2.efi = true;
  ec2.zfsRoot = true;
  networking.hostId = "00000000";
  fileSystems = {
    "/" = {
      device  = "tank/system/root";
      fsType = "zfs";
    };
    "/home" = {
      "device" = "tank/user/home";
      "fsType" = "zfs";
    };
    "/nix" = {
      "device" = "tank/local/nix";
      "fsType" = "zfs";
    };
    "/var" = {
      "device" = "tank/system/var";
      "fsType" = "zfs";
    };
  };
}
