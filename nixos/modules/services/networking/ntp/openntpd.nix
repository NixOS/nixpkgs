{
  pkgs,
  lib,
  config,
  options,
  ...
}:

let
  cfg = config.services.openntpd;

  package = pkgs.openntpd_nixos;

  inherit (lib)
    mkEnableOption
    mkIf
    mkForce
    mkOption
    literalExpression
    types
    ;

  configFile = pkgs.writeText "ntpd.conf" ''
    ${builtins.concatStringsSep "\n" (map (s: "servers ${s}") cfg.servers)}
    ${cfg.extraConfig}
  '';

in
{
  ###### interface

  options.services.openntpd = {
    enable = mkEnableOption "OpenNTP time synchronization server";

    servers = mkOption {
      default = config.services.ntp.servers;
      defaultText = literalExpression "config.services.ntp.servers";
      type = types.listOf types.str;
      inherit (options.services.ntp.servers) description;
    };

    extraConfig = mkOption {
      type = with types; lines;
      default = "";
      example = ''
        listen on 127.0.0.1
        listen on ::1
      '';
      description = ''
        Additional text appended to {file}`openntpd.conf`.
      '';
    };

    extraOptions = mkOption {
      type = with types; separatedString " ";
      default = "";
      example = "-s";
      description = ''
        Extra options used when launching openntpd.
      '';
    };
  };

  ###### implementation

  meta.maintainers = with lib.maintainers; [ thoughtpolice ];

  config = mkIf cfg.enable {
    services.timesyncd.enable = mkForce false;

    # Add ntpctl to the environment for status checking
    environment.systemPackages = [ package ];

    users.users.ntp = {
      isSystemUser = true;
      group = "ntp";
      description = "OpenNTP daemon user";
      home = "/var/empty";
    };
    users.groups.ntp = { };

    systemd = {
      services.openntpd = {
        description = "OpenNTP Server";
        wantedBy = [ "multi-user.target" ];
        wants = [
          "network-online.target"
          "time-sync.target"
        ];
        before = [ "time-sync.target" ];
        after = [
          "dnsmasq.service"
          "bind.service"
          "network-online.target"
        ];
        serviceConfig = {
          ExecStart = "${package}/sbin/ntpd -d -f ${configFile} ${cfg.extraOptions}";
          Type = "exec";
        };
      };

      tmpfiles.rules = [
        "f /var/db/ntpd.drift 0600 root root - 0.000"
      ];
    };
  };
}
