{
  config,
  lib,
  pkgs,
  utils,
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
        See <https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-configuration-file>
      '';
    };

    package = lib.mkPackageOption pkgs "docker" { };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = ''
        Extra packages to add to PATH for the docker daemon process.
      '';
    };

    autoPrune = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to periodically prune Docker resources. If enabled, a
          systemd timer will run `docker system prune -f`
          as specified by the `dates` option.
        '';
      };

      flags = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "--all" ];
        description = ''
          Any additional flags passed to {command}`docker system prune`.
        '';
      };

      dates = lib.mkOption {
        default = "weekly";
        type = lib.types.str;
        description = ''
          Specification (in the format described by
          {manpage}`systemd.time(7)`) of the time at
          which the prune will occur.
        '';
      };

      randomizedDelaySec = lib.mkOption {
        default = "0";
        type = lib.types.singleLineStr;
        example = "45min";
        description = ''
          Add a randomized delay before each auto prune.
          The delay will be chosen between zero and this value.
          This value must be a time span in the format specified by
          {manpage}`systemd.time(7)`
        '';
      };

      persistent = lib.mkOption {
        default = true;
        type = lib.types.bool;
        example = false;
        description = ''
          Takes a boolean argument. If true, the time when the service
          unit was last triggered is stored on disk. When the timer is
          activated, the service unit is triggered immediately if it
          would have been triggered at least once during the time when
          the timer was inactive. Such triggering is nonetheless
          subject to the delay imposed by RandomizedDelaySec=. This is
          useful to catch up on missed runs of the service when the
          system was powered down.
        '';
      };
    };
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
      path = [ "/run/wrappers" ] ++ cfg.extraPackages;
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
        LimitNOFILE = "infinity";
        LimitNPROC = "infinity";
        LimitCORE = "infinity";
        Delegate = true;
        NotifyAccess = "all";
        KillMode = "mixed";
      };
      unitConfig = {
        StartLimitBurst = 3;
      };
    };

    systemd.user.services.docker-prune = {
      description = "Prune docker resources";

      restartIfChanged = false;
      unitConfig.X-StopOnRemoval = false;

      serviceConfig = {
        Type = "oneshot";
        ExecStart = utils.escapeSystemdExecArgs (
          [
            (lib.getExe cfg.package)
            "system"
            "prune"
            "-f"
          ]
          ++ cfg.autoPrune.flags
        );
      };

      startAt = lib.optional cfg.autoPrune.enable cfg.autoPrune.dates;
      after = [ "docker.service" ];
      requires = [ "docker.service" ];
    };

    systemd.user.timers.docker-prune = lib.mkIf cfg.autoPrune.enable {
      timerConfig = {
        RandomizedDelaySec = cfg.autoPrune.randomizedDelaySec;
        Persistent = cfg.autoPrune.persistent;
      };
    };
  };

}
