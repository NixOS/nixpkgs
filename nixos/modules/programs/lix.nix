{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.nix;

  nixPackage = cfg.package.out;

  commonNixDaemonConfig = {
    path = [
      nixPackage
      config.programs.ssh.package
    ];

    environment =
      cfg.envVars
      // {
        CURL_CA_BUNDLE = config.security.pki.caBundle;
      }
      // config.networking.proxy.envVars;

    serviceConfig = {
      CPUSchedulingPolicy = cfg.daemonCPUSchedPolicy;
      IOSchedulingClass = cfg.daemonIOSchedClass;
      IOSchedulingPriority = cfg.daemonIOSchedPriority;
    };
  };

  makeNixBuildUser = nr: {
    name = "nixbld${toString nr}";
    value = {
      description = "Lix build user ${toString nr}";
      uid = builtins.add config.ids.uids.nixbld nr;
      isSystemUser = true;
      group = "nixbld";
      extraGroups = [ "nixbld" ];
    };
  };

  nixbldUsers = lib.listToAttrs (map makeNixBuildUser (lib.range 1 cfg.nrBuildUsers));

in

{
  config = lib.mkIf (cfg.enable && nixPackage.pname == "lix") {
    environment.systemPackages = [
      nixPackage
      pkgs.nix-info
    ]
    ++ lib.optional (config.programs.bash.completion.enable) pkgs.nix-bash-completions;

    systemd.packages = [ nixPackage ];

    systemd.tmpfiles.packages = [ nixPackage ];

    systemd.sockets.nix-daemon.wantedBy = [ "sockets.target" ];

    systemd.services."nix-daemon@" = lib.mkMerge [
      commonNixDaemonConfig
      {
        # Do not kill connections serving established connections on upgrade.
        restartIfChanged = false;
      }
    ];

    systemd.services.nix-daemon = lib.mkMerge [
      commonNixDaemonConfig
      {
        restartTriggers = [ config.environment.etc."nix/nix.conf".source ];

        # `stopIfChanged = false` changes to switch behavior
        # from   stop -> update units -> start
        #   to   update units -> restart
        #
        # The `stopIfChanged` setting therefore controls a trade-off between a
        # more predictable lifecycle, which runs the correct "version" of
        # the `ExecStop` line, and on the other hand the availability of
        # sockets during the switch, as the effectiveness of the stop operation
        # depends on the socket being stopped as well.
        #
        # As `nix-daemon.service` does not make use of `ExecStop`, we prefer
        # to keep the socket up and available. This is important for machines
        # that run Nix-based services, such as automated build, test, and deploy
        # services, that expect the daemon socket to be available at all times.
        #
        # Notably, the Nix client does not retry on failure to connect to the
        # daemon socket, and the in-process RemoteStore instance will disable
        # itself. This makes retries infeasible even for services that are
        # aware of the issue. Failure to connect can affect not only new client
        # processes, but also new RemoteStore instances in existing processes,
        # as well as existing RemoteStore instances that have not saturated
        # their connection pool.
        #
        # Also note that `stopIfChanged = true` does not kill existing
        # connection handling daemons, as one might wish to happen before a
        # breaking Nix upgrade (which is rare). The daemon forks that handle
        # the individual connections split off into their own sessions, causing
        # them not to be stopped by systemd.
        # If a Nix upgrade does require all existing daemon processes to stop,
        # nix-daemon must do so on its own accord, and only when the new version
        # starts and detects that Nix's persistent state needs an upgrade.
        stopIfChanged = false;

      }
    ];

    # Set up the environment variables for running Nix.
    environment.sessionVariables = cfg.envVars;

    nix.nrBuildUsers = lib.mkDefault (
      if cfg.settings.auto-allocate-uids or false then
        0
      else
        lib.max 32 (if cfg.settings.max-jobs == "auto" then 0 else cfg.settings.max-jobs)
    );

    users.users = nixbldUsers;

    services.displayManager.hiddenUsers = lib.attrNames nixbldUsers;

    # Legacy configuration conversion.
    nix.settings.sandbox-fallback = false;
  };
}
