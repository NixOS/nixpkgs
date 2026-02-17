{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.idescriptor;
in
{
  options.programs.idescriptor = {
    enable = lib.mkEnableOption "iDescriptor, a cross-platform iDevice management tool";

    package = lib.mkPackageOption pkgs "idescriptor" { };

    users = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "Users to be added to the idevice group.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services = {
      udev.packages = [ cfg.package ];

      usbmuxd.enable = true;
    };

    users.groups.idevice = {
      members = cfg.users;
    };
  };

  meta.maintainers = with lib.maintainers; [ amadejkastelic ];
}
