{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.k40-whisperer;
  pkg = cfg.package.override {
    udevGroup = cfg.group;
  };
in
{
  options.programs.k40-whisperer = {
    enable = lib.mkEnableOption "K40-Whisperer";

    group = lib.mkOption {
      type = lib.types.str;
      description = ''
        Group assigned to the device when connected.
      '';
      default = "k40";
    };

    package = lib.mkPackageOption pkgs "k40-whisperer" { };
  };

  config = lib.mkIf cfg.enable {
    users.groups.${cfg.group} = { };

    environment.systemPackages = [ pkg ];
    services.udev.packages = [ pkg ];
  };
}
