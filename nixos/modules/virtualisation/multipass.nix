{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.virtualisation.multipass;
in
{
  options = {
    virtualisation.multipass = {
      enable = lib.mkEnableOption (lib.mdDoc ''
        Multipass, a simple manager for virtualised Ubuntu instances.
      '');

      logLevel = lib.mkOption {
        type = lib.types.enum [ "error" "warning" "info" "debug" "trace" ];
        default = "debug";
        description = lib.mdDoc ''
          The logging verbosity of the multipassd binary.
        '';
      };

      package = lib.mkPackageOption pkgs "multipass" { };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.multipass = {
      description = "Multipass orchestrates virtual Ubuntu instances.";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      environment = {
        "XDG_DATA_HOME" = "/var/lib/multipass/data";
        "XDG_CACHE_HOME" = "/var/lib/multipass/cache";
        "XDG_CONFIG_HOME" = "/var/lib/multipass/config";
      };

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/multipassd --logger platform --verbosity ${cfg.logLevel}";
        SyslogIdentifier = "multipassd";
        Restart = "on-failure";
        TimeoutStopSec = 300;
        Type = "simple";

        WorkingDirectory = "/var/lib/multipass";

        StateDirectory = "multipass";
        StateDirectoryMode = "0750";
        CacheDirectory = "multipass";
        CacheDirectoryMode = "0750";
      };
    };
  };
}
