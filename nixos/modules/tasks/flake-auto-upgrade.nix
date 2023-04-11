{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.flakeAutoUpgrade;
  mkBuilds = attrs:
    if length attrs == 0 then
      ""
    else ''
      ${pkgs.nix}/bin/nix build .#${head attrs}
      if [ "$?" -neq 0 ]; then
        echo ${head attrs} >> fail.log
        ${mkBuilds (tail attrs)}
      fi
    '';
  knownHostsFile = pkgs.writeText "knownHostsFile" cfg.ssh.hostKey;

in {
  options = {

    services.flakeAutoUpgrade = {

      enable = mkEnableOption (mdDoc "Wether to update the flake");

      remote = mkOption {
        type = types.nullOr types.str;
        description = "Remote to fetch from";
      };

      credentials = mkOption {
        default = null;
        description = "credentials to access the remote";
        type = types.nullOr (types.submodule {
          options = {
            user = mkOption {
              default = null;
              type = types.nullOr types.str;
              description = "User to authenticate with";
            };
            passwordFile = mkOption {
              default = null;
              type = types.nullOr types.path;
              description =
                "File which contains the password or access token to connect to the remote";
            };
          };
        });
      };
      ssh = mkOption {
        default = null;
        description = "ssh option for ssh remote";
        type = types.nullOr (types.submodule {
          options = {
            key = mkOption {
              type = types.path;
              description =
                "path to ssh key with access to the remote repository";
            };
            hostKey = mkOption {
              type = types.str;
              description =
                "path to ssh key with access to the remote repository";
            };
          };
        });
      };
      updateBranch = mkOption {
        type = types.str;
        description = "The branch which should be updated";
      };
      mainBranch = mkOption {
        default = "main";
        type = types.str;
        description = "The branch which should be merged before update";
      };
      buildAttributes = mkOption {
        type = types.listOf types.str;
        description =
          "Attributes to build. This will build until one of them succeeds";
      };
      updateScript = mkOption {
        default = "${pkgs.nix}/bin/nix flake update --commit-lock-file";
        type = types.str;
        description = "Command to update the config";
      };

      postCommands = mkOption {
        default = ''
          ${pkgs.git}/bin/git commit --amend -m '$(${pkgs.git}/bin/git log -n1 --pretty=%B)
          $(cat fail.log)'
        '';
        type = types.str;
        description = ''
          Commands to be executed after the update
          This can use failed.log, which stores a list of the failed `buildAttributes`, to see which builds faild
        '';
      };

      dates = mkOption {
        type = types.str;
        default = "04:40";
        example = "daily";
        description = lib.mdDoc ''
          How often or when upgrade occurs. For most desktop and server systems
          a sufficient upgrade frequency is once a day.

          The format is described in
          {manpage}`systemd.time(7)`.
        '';
      };

      randomizedDelaySec = mkOption {
        default = "0";
        type = types.str;
        example = "45min";
        description = lib.mdDoc ''
          Add a randomized delay before each automatic upgrade.
          The delay will be chosen between zero and this value.
          This value must be a time span in the format specified by
          {manpage}`systemd.time(7)`
        '';
      };

      persistent = mkOption {
        default = true;
        type = types.bool;
        example = false;
        description = lib.mdDoc ''
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

  config = mkIf cfg.enable {

    systemd.services.flake-auto-upgrade = {
      description = "Nix updater";
      environment = mkMerge [
        (mkIf (cfg.ssh != null) {
          GIT_SSH_COMMAND =
            "${pkgs.openssh}/bin/ssh -i $CREDENTIALS_DIRECTORY/sshKey -o GlobalKnownHostsFile=${knownHostsFile}";
        })
        (mkIf (cfg.credentials != null) {
          GIT_ASKPASS = ''
            case "$1" in
                Username*) exec echo ${cfg.credentials.user}" ;;
                Password*) exec cat $CREDENTIALS_DIRECTORY/passwordFile" ;;
            esac
          '';
        })
      ];
      serviceConfig = mkMerge [
        {
          CapabilityBoundingSet = "";
          LockPersonality = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          PrivateDevices = true;
          WorkingDirectory = "/var/lib/updater";
          StateDirectory = "updater";
          RestrictNamespaces = true;
          RestrictRealtime = true;
          DynamicUser = true;
        }
        (mkIf (cfg.credentials != null) {
          LoadCredential = "passwordFile:${cfg.credentials.passwordFile}";
        })
        (mkIf (cfg.ssh != null) { LoadCredential = "sshKey:${cfg.ssh.key}"; })
      ];
      script = ''
        if [ ! -d repo ]; then
          ${pkgs.git}/bin/git clone ${cfg.remote} repo
          cd repo
        else
          cd repo
          ${pkgs.git}/bin/git fetch
        fi
        ${pkgs.git}/bin/git checkout ${cfg.updateBranch} || ${pkgs.git}/bin/git checkout -b ${cfg.updateBranch}
        ${pkgs.git}/bin/git pull || true
        ${pkgs.git}/bin/git merge origin/${cfg.mainBranch} || true
        rm -f *.log
        ${cfg.updateScript}
        ${mkBuilds cfg.buildAttributes}
        ${cfg.postCommands}
        ${pkgs.git}/bin/git push || ${pkgs.git}/bin/git push --set-upstream
      '';

      startAt = cfg.dates;

    };

    systemd.timers.nixos-upgrade = {
      timerConfig = {
        RandomizedDelaySec = cfg.randomizedDelaySec;
        Persistent = cfg.persistent;
      };
    };
  };
}
