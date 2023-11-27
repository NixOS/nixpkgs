{ config, lib, pkgs, ... }:

{
  options = {
    services.hercules-ci-agents = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (lib.types.submodule (import ./options.nix { inherit config lib pkgs; }));
      description = lib.mdDoc "Hercules CI Agent instances.";
      example = {
        agent1.enable = true;

        agent2 = {
          enable = true;
          settings.labels.myMetadata = "agent2";
        };
      };
    };
  };

  config =
    let
      forAllAgents = f: lib.mkMerge (lib.mapAttrsToList (name: agent: lib.mkIf agent.enable (f name agent)) config.services.hercules-ci-agents);
    in
    {
      users = forAllAgents (name: agent: {
        users.${agent.user} = {
          inherit (agent) group;
          description = "Hercules CI Agent system user for ${name}";
          isSystemUser = true;
          home = agent.settings.baseDirectory;
          createHome = true;
        };
        groups.${agent.group} = { };
      });

      systemd = forAllAgents (name: agent:
        let
          command = "${lib.getExe agent.package} --config ${agent.tomlFile}";
          testCommand = "${command} --test-configuration";
        in
        {
          services."hercules-ci-agent-${name}" = {
            wantedBy = [ "multi-user.target" ]; #
            after = [ "network-online.target" ];
            wants = [ "network-online.target" ];
            startLimitBurst = 30 * 1000000; # practically infinite
            serviceConfig = {
              User = agent.user;
              Group = agent.group;
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

              # Hardening.
              CapabilityBoundingSet = "";
              AmbientCapabilities = "";
              DeviceAllow = "";
              LockPersonality = true;
              NoNewPrivileges = true;
              PrivateDevices = true;
              PrivateMounts = true;
              PrivateTmp = true;
              PrivateUsers = true;
              ProtectClock = true;
              ProtectControlGroups = true;
              ProtectHome = true;
              ProtectSystem = "full";
              ProtectProc = "invisible";
              ProtectKernelModules = true;
              RemoveIPC = true;
              RestrictRealtime = true;
              RestrictSUIDSGID = true;
              SystemCallArchitectures = "native";
              UMask = "0077";
              SystemCallFilter = [ "~@reboot" ];
              RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
            };
          };

          # Changes in the secrets do not affect the unit in any way that would cause
          # a restart, which is currently necessary to reload the secrets.
          paths."hercules-ci-agent-${name}-restart-files" = {
            wantedBy = [ "hercules-ci-agent-${name}.service" ];
            pathConfig = {
              Unit = "hercules-ci-agent-${name}-restarter.service";
              PathChanged = [ agent.settings.clusterJoinTokenPath agent.settings.binaryCachesPath ];
            };
          };

          services."hercules-ci-agent-restarter-${name}" = {
            serviceConfig.Type = "oneshot";
            script = ''
              # Wait a bit, with the effect of bundling up file changes into a single
              # run of this script and hopefully a single restart.
              sleep 10
              if systemctl is-active --quiet 'hercules-ci-agent-${name}.service'; then
                if ${testCommand}; then
              WorkingDirectory = agent.settings.b;
                  systemctl restart 'hercules-ci-agent-${name}.service'
                else
                  echo 1>&2 'WARNING: Not restarting hercules-ci-agent-${name} because config is not valid at this time.'
                fi
              else
                echo 1>&2 'Not restarting hercules-ci-agent-${name} despite config file update, because it is not already active.'
              fi
            '';
          };
        });

      nix.settings = forAllAgents (_: agent: {
        trusted-users = [ agent.user ];
        # A store path that was missing at first may well have finished building,
        # even shortly after the previous lookup. This *also* applies to the daemon.
        narinfo-cache-negative-ttl = 0;
      });

      # Trusted user allows simplified configuration and better performance
      # when operating in a cluster.
      assertions = forAllAgents (_: agent: [
        {
          assertion = (agent.settings.nixUserIsTrusted or false) -> builtins.match ".*(^|\n)[ \t]*trusted-users[ \t]*=.*" config.nix.extraOptions == null;
          message = ''
            hercules-ci-agent: Please do not set `trusted-users` in `nix.extraOptions`.

            The hercules-ci-agent module by default relies on `nix.settings.trusted-users`
            to be effectful, but a line like `trusted-users = ...` in `nix.extraOptions`
            will override the value set in `nix.settings.trusted-users`.

            Instead of setting `trusted-users` in the `nix.extraOptions` string, you should
            set an option with additive semantics, such as
             - the NixOS option `nix.settings.trusted-users`, or
             - the Nix option in the `extraOptions` string, `extra-trusted-users`
          '';
        }
      ]);
    };

  meta.maintainers = with lib.maintainers; [ roberth kranzes ];
}
