{ config, pkgs, lib, ... }:

with lib;

let
  pkg = pkgs.realmd;
  cfg = config.services.realmd;
in
{
  options.services.realmd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable the realmd service which allows using `realm` to join
        machines to AD/LDAP domains.
      '';
    };

    configText = mkOption {
      type = types.lines;
      default = "";
      description = "The verbatim contents of config file /etc/realmd.conf";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.realmd pkgs.oddjob pkgs.adcli ];
    systemd.packages = [ pkgs.realmd pkgs.oddjob pkgs.packagekit ];

    systemd.services.realmd = {
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      description = "Realm and Domain Configuration";
      enable = true;
      documentation = ["man:realm(8)" "man:realmd.conf(5)"];
      serviceConfig = {
        Type = "dbus";
        BusName = "org.freedesktop.realmd";
        ExecStart = "${pkgs.realmd}/libexec/realmd";
      };
    };

    environment.etc."realmd.conf" = {
      target = "realmd.conf";
      source = pkgs.writeText "realmd.conf" "${cfg.configText}";
    };
  };
}
