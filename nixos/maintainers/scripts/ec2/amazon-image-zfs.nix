{
  imports = [ ./amazon-image.nix ];
  ec2.zfs = {
    enable = true;
    datasets = {
      "tank/system/root".mount = "/";
      "tank/system/var".mount = "/var";
      "tank/local/nix".mount = "/nix";
      "tank/user/home".mount = "/home";
    };
  };
}
