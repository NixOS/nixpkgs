{ pkgs, lib, config, options, ... }:

with lib;

let
  cfg = config.services.openntpd;

  package = pkgs.openntpd_nixos;

  configFile = ''
    ${concatStringsSep "\n" (map (s: "server ${s}") cfg.servers)}
    ${cfg.extraConfig}
  '';

  pidFile = "/run/openntpd.pid";

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

  config = mkIf cfg.enable {
    meta.maintainers = with lib.maintainers; [ thoughtpolice ];
    services.timesyncd.enable = mkForce false;

    # Add ntpctl to the environment for status checking
    environment.systemPackages = [ package ];

    environment.etc."ntpd.conf".text = configFile;

    users.users.ntp = {
      isSystemUser = true;
      group = "ntp";
      description = "OpenNTP daemon user";
      home = "/var/empty";
    };
    users.groups.ntp = {};

    systemd.services.openntpd = {
      description = "OpenNTP Server";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" "time-sync.target" ];
      before = [ "time-sync.target" ];
      after = [ "dnsmasq.service" "bind.service" "network-online.target" ];
      serviceConfig = {
        ExecStart = "${package}/sbin/ntpd -p ${pidFile} ${cfg.extraOptions}";
        Type = "forking";
        PIDFile = pidFile;
      };
    };
  };
}
