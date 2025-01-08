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

  configFile = ''
    ${lib.concatStringsSep "\n" (map (s: "server ${s}") cfg.servers)}
    ${cfg.extraConfig}
  '';

  pidFile = "/run/openntpd.pid";

in
{
  ###### interface

  options.services.openntpd = {
    enable = lib.mkEnableOption "OpenNTP time synchronization server";

    servers = lib.mkOption {
      default = config.services.ntp.servers;
      defaultText = lib.literalExpression "config.services.ntp.servers";
      type = lib.types.listOf lib.types.str;
      inherit (options.services.ntp.servers) description;
    };

    extraConfig = lib.mkOption {
      type = with lib.types; lines;
      default = "";
      example = ''
        listen on 127.0.0.1
        listen on ::1
      '';
      description = ''
        Additional text appended to {file}`openntpd.conf`.
      '';
    };

    extraOptions = lib.mkOption {
      type = with lib.types; separatedString " ";
      default = "";
      example = "-s";
      description = ''
        Extra options used when launching openntpd.
      '';
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    meta.maintainers = with lib.maintainers; [ thoughtpolice ];
    services.timesyncd.enable = lib.mkForce false;

    # Add ntpctl to the environment for status checking
    environment.systemPackages = [ package ];

    environment.etc."ntpd.conf".text = configFile;

    users.users.ntp = {
      isSystemUser = true;
      group = "ntp";
      description = "OpenNTP daemon user";
      home = "/var/empty";
    };
    users.groups.ntp = { };

    systemd.services.openntpd = {
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
        ExecStart = "${package}/sbin/ntpd -p ${pidFile} ${cfg.extraOptions}";
        Type = "forking";
        PIDFile = pidFile;
      };
    };
  };
}
