{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.dnsdist;
  configFile = pkgs.writeText "dndist.conf" ''
    setLocal('${cfg.listenAddress}:${toString cfg.listenPort}')
    ${cfg.extraConfig}
  '';
in {
  options = {
    services.dnsdist = {
      enable = mkEnableOption "dnsdist domain name server";

      listenAddress = mkOption {
        type = types.str;
        description = "Listen IP Address";
        default = "0.0.0.0";
      };
      listenPort = mkOption {
        type = types.int;
        description = "Listen port";
        default = 53;
      };

      extraConfig = mkOption {
        type = types.lines;
        default = ''
        '';
        description = ''
          Extra lines to be added verbatim to dnsdist.conf.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.packages = [ pkgs.dnsdist ];

    systemd.services.dnsdist = {
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        DynamicUser = true;

        # upstream overrides for better nixos compatibility
        ExecStartPre = [ "" "${pkgs.dnsdist}/bin/dnsdist --check-config --config ${configFile}" ];
        ExecStart = [ "" "${pkgs.dnsdist}/bin/dnsdist --supervised --disable-syslog --config ${configFile}" ];
      };
    };
  };
}
