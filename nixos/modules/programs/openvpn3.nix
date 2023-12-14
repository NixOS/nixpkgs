{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.openvpn3;
in
{
  options.programs.openvpn3 = {
    enable = mkEnableOption (lib.mdDoc "the openvpn3 client");
    package = mkOption {
      type = types.package;
      default = pkgs.openvpn3.override {
        enableSystemdResolved = config.services.resolved.enable;
      };
      defaultText = literalExpression ''pkgs.openvpn3.override {
        enableSystemdResolved = config.services.resolved.enable;
      }'';
      description = lib.mdDoc ''
        Which package to use for `openvpn3`.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.dbus.packages = [
      cfg.package
    ];

    users.users.openvpn = {
      isSystemUser = true;
      uid = config.ids.uids.openvpn;
      group = "openvpn";
    };

    users.groups.openvpn = {
      gid = config.ids.gids.openvpn;
    };

    environment.systemPackages = [
      cfg.package
    ];
  };

}
