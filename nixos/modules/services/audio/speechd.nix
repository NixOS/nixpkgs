{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.speechd;
#  configDir = pkgs.writeTextDir "pdns.conf" "${cfg.extraConfig}";
in {
  options = {
    services.speechd = {
      enable = mkEnableOption "Speech-Dispatcher";

#      extraConfig = mkOption {
#        type = types.lines;
#        default = "launch=bind";
#        description = ''
#          Extra lines to be added verbatim to the config file.
#        '';
#      };

    };
  };

  config = mkIf config.services.speechd.enable {
    systemd = {
      packages = [ pkgs.speechd ];

#      services.pdns = {
#        wantedBy = [ "multi-user.target" ];
#        serviceConfig = {
#          ExecStart = [
 #           ""
#            "${pkgs.powerdns}/bin/pdns_server --guardian=no --daemon=no --disable-syslog --log-timestamp=no --write-pid=no --config-dir=${configDir}"
#          ];
#        };
        
      };
    };
  };
}