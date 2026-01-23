/*
  This file is for NixOS-specific options and configs.

  Code that is shared with nix-darwin goes in common.nix.
*/

{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkDefault;

  cfg = config.services.hercules-ci-agent;

  command = "${cfg.package}/bin/hercules-ci-agent --config ${cfg.tomlFile}";
  testCommand = "${command} --test-configuration";

in
{
  imports = [
    ./common.nix
    (lib.mkRenamedOptionModule
      [ "services" "hercules-ci-agent" "user" ]
      [ "systemd" "services" "hercules-ci-agent" "serviceConfig" "User" ]
    )
  ];

  config = mkIf cfg.enable {
    systemd.services.hercules-ci-agent = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      path = [ config.nix.package ];
      startLimitBurst = 30 * 1000000; # practically infinite
      serviceConfig = {
        User = "hercules-ci-agent";
        ExecStart = command;
        ExecStartPre = testCommand;
        Restart = "on-failure";
        RestartSec = 120;

        # If a worker goes OOM, don't kill the main process. It needs to
        # report the failure and it's unlikely to be part of the problem.
        OOMPolicy = "continue";

        # Work around excessive stack use by libstdc++ regex
        # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=86164
        # A 256 MiB stack allows between 400 KiB and 1.5 MiB file to be matched by ".*".
        LimitSTACK = 256 * 1024 * 1024;
      };
    };

    # Changes in the secrets do not affect the unit in any way that would cause
    # a restart, which is currently necessary to reload the secrets.
    systemd.paths.hercules-ci-agent-restart-files = {
      wantedBy = [ "hercules-ci-agent.service" ];
      pathConfig = {
        Unit = "hercules-ci-agent-restarter.service";
        PathChanged = [
          cfg.settings.clusterJoinTokenPath
          cfg.settings.binaryCachesPath
        ];
      };
    };
    systemd.services.hercules-ci-agent-restarter = {
      serviceConfig.Type = "oneshot";
      script = ''
        # Wait a bit, with the effect of bundling up file changes into a single
        # run of this script and hopefully a single restart.
        sleep 10
        if systemctl is-active --quiet hercules-ci-agent.service; then
          if ${testCommand}; then
            systemctl restart hercules-ci-agent.service
          else
            echo 1>&2 "WARNING: Not restarting agent because config is not valid at this time."
          fi
        else
          echo 1>&2 "Not restarting hercules-ci-agent despite config file update, because it is not already active."
        fi
      '';
    };

    # Trusted user allows simplified configuration and better performance
    # when operating in a cluster.
    nix.settings.trusted-users = [ config.systemd.services.hercules-ci-agent.serviceConfig.User ];
    services.hercules-ci-agent = {
      settings = {
        nixUserIsTrusted = true;
        labels =
          let
            mkIfNotNull = x: mkIf (x != null) x;
          in
          {
            nixos.configurationRevision = mkIfNotNull config.system.configurationRevision;
            nixos.release = config.system.nixos.release;
            nixos.label = mkIfNotNull config.system.nixos.label;
            nixos.codeName = config.system.nixos.codeName;
            nixos.tags = config.system.nixos.tags;
            nixos.systemName = mkIfNotNull config.system.name;
          };
      };
    };

    users.users.hercules-ci-agent = {
      home = cfg.settings.baseDirectory;
      createHome = true;
      group = "hercules-ci-agent";
      description = "Hercules CI Agent system user";
      isSystemUser = true;
    };

    users.groups.hercules-ci-agent = { };
  };

  meta.maintainers = [ lib.maintainers.roberth ];
}
