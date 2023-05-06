{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.flakeAutoUpgrade;
  nixCommand =
    "${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes'";
  mkBuilds = attrs:
    if length attrs == 0 then
      ""
    else ''
      if ! ${nixCommand} build .#${head attrs};
      then
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
        description = lib.mdDoc "Remote to fetch from";
      };

      credentials = mkOption {
        default = null;
        description = lib.mdDoc "credentials to access the remote";
        type = types.nullOr (types.submodule {
          options = {
            user = mkOption {
              default = null;
              type = types.nullOr types.str;
              description = lib.mdDoc "User to authenticate with";
            };
            passwordFile = mkOption {
              default = null;
              type = types.nullOr types.path;
              description = lib.mdDoc
                "File which contains the password or access token to connect to the remote";
            };
          };
        });
      };
      ssh = mkOption {
        default = null;
        description = lib.mdDoc "ssh option for ssh remote";
        type = types.nullOr (types.submodule {
          options = {
            key = mkOption {
              type = types.path;
              description = lib.mdDoc
                "path to ssh key with access to the remote repository";
            };
            hostKey = mkOption {
              type = types.str;
              description =
                lib.mdDoc "name of host and its public key for fingerprint";
            };
          };
        });
      };
      updateBranch = mkOption {
        type = types.str;
        description = lib.mdDoc "The branch which should be updated";
      };
      mainBranch = mkOption {
        default = "main";
        type = types.str;
        description =
          lib.mdDoc "The branch which should be merged before update";
      };
      buildAttributes = mkOption {
        type = types.listOf types.str;
        description = lib.mdDoc
          "Attributes to build. This will build until one of them succeeds";
      };
      updateFlake = mkOption {
        default = true;
        type = types.bool;
        description = lib.mdDoc "Wether to update the flake before building";
      };

      updateScript = mkOption {
        default = "";
        type = types.str;
        description = lib.mdDoc "Command to update the config";
      };

      failLogInCommitMsg = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Wether to append a list of the failed `buildAttributes` to the commit message
        '';
      };

      postCommands = mkOption {
        default = "";
        type = types.str;
        description = lib.mdDoc ''
          Commands to be executed after the update
          This can use fail.log, which stores a list of the failed `buildAttributes`, to see which builds failed
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
          GIT_ASKPASS = pkgs.writeShellScript "askpass" ''
            case "$1" in
                Username*)
                  echo ${cfg.credentials.user}
                  ;;
                Password*)
                  cat $CREDENTIALS_DIRECTORY/passwordFile
                  ;;
            esac
          '';
        })
        { EMAIL = "<>"; }
      ];
      serviceConfig = mkMerge [
        {
          type = "oneshot";
          CapabilityBoundingSet = "";
          LockPersonality = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          PrivateDevices = true;
          WorkingDirectory = "/var/lib/flake-auto-upgrade";
          StateDirectory = "flake-auto-upgrade";
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
          cd repo || exit
        else
          cd repo || exit
          ${pkgs.git}/bin/git fetch
        fi
        rm -f ./*.log
        if ${pkgs.git}/bin/git checkout ${cfg.updateBranch};
        then
          # We don't pull because a force push could have happend in the meantime
          ${pkgs.git}/bin/git reset --hard origin/${cfg.updateBranch}
        else
          ${pkgs.git}/bin/git checkout -b ${cfg.updateBranch}
        fi
        ${pkgs.git}/bin/git merge origin/${cfg.mainBranch} || true
        ${lib.optionalString cfg.updateFlake ''
          ${nixCommand} flake update --commit-lock-file
        ''}
        ${cfg.updateScript}
        ${mkBuilds cfg.buildAttributes}
        ${lib.optionalString cfg.failLogInCommitMsg ''
          oldmessage=$(${pkgs.git}/bin/git log -n1 --pretty=%B)
          faillog=$(cat fail.log | ${pkgs.gawk}/bin/awk '{print $0 " failed"}')
          ${pkgs.git}/bin/git commit --amend -m "$(echo $oldmessage; printf "\n\n"; echo $faillog)"
        ''}
        ${cfg.postCommands}
        ${pkgs.git}/bin/git push || ${pkgs.git}/bin/git push --set-upstream origin ${cfg.updateBranch}
      '';

      startAt = cfg.dates;

    };

    systemd.timers.flake-auto-upgrade = {
      timerConfig = {
        RandomizedDelaySec = cfg.randomizedDelaySec;
        Persistent = cfg.persistent;
      };
    };
  };
}
