{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.yubikey-manager;
in
{
  options = {
    programs.yubikey-manager = {
      enable = lib.mkEnableOption "yubikey-manager";

      package = lib.mkPackageOption pkgs "yubikey-manager" { };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services = {
      pcscd.enable = true;

      # The udev rules we want aren't included in the yubikey-manager package, but
      # we can get them from yubikey-personalization.
      udev.packages = [ pkgs.yubikey-personalization ];
    };
  };
}
