{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.virtualisation.docker.rootless;
  proxy_env = config.networking.proxy.envVars;
  settingsFormat = pkgs.formats.json { };
  daemonSettingsFile = settingsFormat.generate "daemon.json" cfg.daemon.settings;

in

{
  ###### interface

  options.virtualisation.docker.rootless = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        This option enables docker in a rootless mode, a daemon that manages
        linux containers. To interact with the daemon, one needs to set
        {command}`DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock`.
      '';
    };

    setSocketVariable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Point {command}`DOCKER_HOST` to rootless Docker instance for
        normal users by default.
      '';
    };

    daemon.settings = lib.mkOption {
      type = settingsFormat.type;
      default = { };
      example = {
        ipv6 = true;
        "fixed-cidr-v6" = "fd00::/80";
      };
      description = ''
        Configuration for docker daemon. The attributes are serialized to JSON used as daemon.conf.
        See https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-configuration-file
      '';
    };

    package = lib.mkPackageOption pkgs "docker" { };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.extraInit = lib.optionalString cfg.setSocketVariable ''
      if [ -z "$DOCKER_HOST" -a -n "$XDG_RUNTIME_DIR" ]; then
        export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/docker.sock"
      fi
    '';

    # Taken from https://github.com/moby/moby/blob/master/contrib/dockerd-rootless-setuptool.sh
    systemd.user.services.docker = {
      wantedBy = [ "default.target" ];
      description = "Docker Application Container Engine (Rootless)";
      # needs newuidmap from pkgs.shadow
      path = [ "/run/wrappers" ];
      environment = proxy_env;
      unitConfig = {
        # docker-rootless doesn't support running as root.
        ConditionUser = "!root";
        StartLimitInterval = "60s";
      };
      serviceConfig = {
        Type = "notify";
        ExecStart = "${cfg.package}/bin/dockerd-rootless --config-file=${daemonSettingsFile}";
        ExecReload = "${pkgs.procps}/bin/kill -s HUP $MAINPID";
        TimeoutSec = 0;
        RestartSec = 2;
        Restart = "always";
        StartLimitBurst = 3;
        LimitNOFILE = "infinity";
        LimitNPROC = "infinity";
        LimitCORE = "infinity";
        Delegate = true;
        NotifyAccess = "all";
        KillMode = "mixed";
      };
    };
  };

}
