{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.powerdns;
  configDir = pkgs.writeTextDir "pdns.conf" (concatStringsSep "\n" (mapAttrsToList (key: value: "${key}=${toStr value}") cfg.settings));
  toStr = value:
    if value == true then "yes"
    else if value == false then "no"
    else builtins.toString value
  ;
in
{
  imports = [
    (mkRemovedOptionModule [ "services" "powerdns" "extraConfig" ] "Use services.powerdns.settings instead.")
  ];

  options = {
    services.powerdns = {
      enable = mkEnableOption "PowerDNS domain name server";

      settings = mkOption {
        type = with types; attrsOf (oneOf [ bool int str ]);
        description = ''
          PowerDNS configuration. Refer to
          <link xlink:href="https://doc.powerdns.com/authoritative/settings.html"/>
          for details on supported values.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    services.powerdns.settings = {
      launch = mkDefault "bind";
    };

    systemd.packages = [ pkgs.powerdns ];

    systemd.services.pdns = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "mysql.service" "postgresql.service" "openldap.service" ];

      serviceConfig = {
        ExecStart = [ "" "${pkgs.powerdns}/bin/pdns_server --config-dir=${configDir} --guardian=no --daemon=no --disable-syslog --log-timestamp=no --write-pid=no" ];
      };
    };

    users.users.pdns = {
      isSystemUser = true;
      group = "pdns";
      description = "PowerDNS";
    };

    users.groups.pdns = {};

  };
}
