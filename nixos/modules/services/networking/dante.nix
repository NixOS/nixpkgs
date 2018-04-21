{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.services.dante;
  confFile = pkgs.writeText "dante-sockd.conf" ''
    user.privileged: root
    user.unprivileged: dante

    ${cfg.config}
  '';
in

{
  meta = {
    maintainers = with maintainers; [ arobyn ];
  };

  options = {
    services.dante = {
      enable = mkEnableOption "Dante SOCKS proxy";

      config = mkOption {
        default     = null;
        type        = types.nullOr types.str;
        description = ''
          Contents of Dante's configuration file
          NOTE: user.privileged/user.unprivileged are set by the service
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion   = cfg.config != null;
        message     = "please provide Dante configuration file contents";
      }
    ];

    users.users.dante = {
      description   = "Dante SOCKS proxy daemon user";
      isSystemUser  = true;
      group         = "dante";
    };
    users.groups.dante = {};

    systemd.services.dante = {
      description   = "Dante SOCKS v4 and v5 compatible proxy server";
      after         = [ "network-online.target" ];
      wantedBy      = [ "multi-user.target" ];

      serviceConfig = {
        Type        = "simple";
        ExecStart   = "${pkgs.dante}/bin/sockd -f ${confFile}";
        ExecReload  = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        Restart     = "always";
      };
    };
  };
}
