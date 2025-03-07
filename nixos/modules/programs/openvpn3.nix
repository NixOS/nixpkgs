{ config, lib, pkgs, ... }:

let
  cfg = config.programs.openvpn3;
in
{
  options.programs.openvpn3 = {
    enable = lib.mkEnableOption "the openvpn3 client";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.openvpn3.override {
        enableSystemdResolved = config.services.resolved.enable;
      };
      defaultText = lib.literalExpression ''pkgs.openvpn3.override {
        enableSystemdResolved = config.services.resolved.enable;
      }'';
      description = ''
        Which package to use for `openvpn3`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
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
