{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.powerdns;
  configDir = pkgs.writeTextDir "pdns.conf" "${cfg.extraConfig}";
in {
  options = {
    services.powerdns = {
      enable = mkEnableOption "Powerdns domain name server";

      extraConfig = mkOption {
        type = types.lines;
        default = "launch=bind";
        description = ''
          Extra lines to be added verbatim to the config file.
        '';
      };
    };
  };

  config = mkIf config.services.powerdns.enable {
    systemd = {
      packages = [ pkgs.powerdns ];

      services.pdns = {
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = [
            ""
            "${pkgs.powerdns}/bin/pdns_server --guardian=no --daemon=no --disable-syslog --log-timestamp=no --write-pid=no --config-dir=${configDir}"
          ];
        };
      };
    };
  };
}
