{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.services.dante;
  confFile = pkgs.writeText "dante-sockd.conf" ''
    user.privileged: root
    user.unprivileged: dante
    logoutput: syslog

    ${cfg.config}
  '';
in

{
  meta = {
    maintainers = with maintainers; [ arobyn ];
  };

  options = {
    services.dante = {
      enable = mkEnableOption (lib.mdDoc "Dante SOCKS proxy");

      config = mkOption {
        type        = types.lines;
        description = lib.mdDoc ''
          Contents of Dante's configuration file.
          NOTE: user.privileged, user.unprivileged and logoutput are set by the service.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion   = cfg.config != "";
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
        # Can crash sometimes; see https://github.com/NixOS/nixpkgs/pull/39005#issuecomment-381828708
        Restart     = "on-failure";
      };
    };
  };
}
