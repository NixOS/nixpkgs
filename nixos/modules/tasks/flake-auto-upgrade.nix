{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkIf
    mkMerge
    nameValuePair
    optionalString
    types
    mkOption
    mapAttrs'
    getExe
    ;
  nixCommand = "${getExe pkgs.nix} --extra-experimental-features 'nix-command flakes'";
  mkBuilds = attrs: lib.concatMapStrings mkBuild attrs;
  mkBuild =
    attr:
    if builtins.typeOf attr == "string" then
      ''
        if ! ${nixCommand} build .#${attr};
        then
          echo ${attr} >> fail.log
        fi
      ''
    else
      ''
        if ! ${nixCommand} build .#${attr.attr};
        then
          echo ${attr.attr} >> fail.log
          ${mkBuilds attr.onFail}
        fi
      '';
  mkServices =
    name: cfg:
    nameValuePair name {
      description = "Nix updater";
      environment = mkMerge [
        (mkIf (cfg.ssh != null) {
          GIT_SSH_COMMAND =
            let
              knownHostsFile = pkgs.writeText "knownHostsFile" cfg.ssh.hostKey;
            in
            "${getExe pkgs.openssh} -i $CREDENTIALS_DIRECTORY/sshKey -o GlobalKnownHostsFile=${knownHostsFile}";
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
        {
          EMAIL = "<>";
          HOME = "/var/lib/${name}";
        }
      ];
      path = mkMerge [
        (mkIf (cfg.gitCryptKeyFile != null) [ pkgs.git-crypt ])
        [ pkgs.git ]
      ];
      serviceConfig = mkMerge [
        {
          Type = "oneshot";
          CapabilityBoundingSet = "";
          LockPersonality = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          PrivateDevices = true;
          WorkingDirectory = "/var/lib/${name}";
          StateDirectory = name;
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
          ${getExe pkgs.git} clone ${cfg.remote} repo
          cd repo || exit
        else
          cd repo || exit
          ${getExe pkgs.git} fetch
        fi
        ${optionalString (cfg.gitCryptKeyFile != null) ''
          ${getExe pkgs.git-crypt} unlock ${cfg.gitCryptKeyFile}
        ''}
        rm -f ./*.log
        if ${getExe pkgs.git} checkout ${cfg.updateBranch};
        then
          # We don't pull because a force push could have happend in the meantime
          ${getExe pkgs.git} reset --hard origin/${cfg.updateBranch} || true
        else
          ${getExe pkgs.git} checkout -b ${cfg.updateBranch}
        fi
        ${getExe pkgs.git} merge origin/${cfg.mainBranch} || true
        ${optionalString cfg.updateFlake ''
          ${nixCommand} flake update --commit-lock-file
        ''}
        ${cfg.updateScript}
        ${mkBuilds cfg.buildAttributes}
        ${optionalString cfg.failLogInCommitMsg ''
          oldmessage=$(${getExe pkgs.git} log -n1 --pretty=%B)
          faillog=$(cat fail.log | ${getExe pkgs.gawk} '{print $0 " failed"}')
          ${getExe pkgs.git} commit --amend -m "$(echo $oldmessage; printf "\n\n"; echo $faillog)"
        ''}
        ${cfg.postCommands}
        ${getExe pkgs.git} push || ${getExe pkgs.git} push --set-upstream origin ${cfg.updateBranch}
      '';
      startAt = cfg.dates;
    };
  mkTimers =
    name: cfg:
    nameValuePair name {
      timerConfig = {
        RandomizedDelaySec = cfg.randomizedDelaySec;
        Persistent = cfg.persistent;
      };
    };
in
{
  options = {

    services.flakeAutoUpgrade = mkOption {

      description = ''
        Adding a systemd timer to automatically update a flake
        from a given branch on a given remote and build it.
        After the build the updated flake will be pushed to a given
        branch of the remote.
      '';
      default = { };
      type = types.attrsOf (
        types.submodule (

          { ... }:
          {
            options = {
              remote = mkOption {
                type = types.nullOr types.str;
                description = "Remote to fetch from";
              };

              credentials = mkOption {
                default = null;
                description = "credentials to access the remote";
                type = types.nullOr (
                  types.submodule {
                    options = {
                      user = mkOption {
                        default = null;
                        type = types.nullOr types.str;
                        description = "User to authenticate with";
                      };
                      passwordFile = mkOption {
                        default = null;
                        type = types.nullOr types.path;
                        description = "File which contains the password or access token to connect to the remote";
                      };
                    };
                  }
                );
              };
              ssh = mkOption {
                default = null;
                description = "ssh option for ssh remote";
                type = types.nullOr (
                  types.submodule {
                    options = {
                      key = mkOption {
                        type = types.path;
                        description = "path to ssh key with access to the remote repository";
                      };
                      hostKey = mkOption {
                        type = types.str;
                        description = "name of host and its public key for fingerprint";
                      };
                    };
                  }
                );
              };
              gitCryptKeyFile = mkOption {
                default = null;
                type = types.nullOr types.path;
                description = "Path of git-crypt key for decryption";
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
                type =
                  with types;
                  listOf (oneOf [
                    str
                    (submodule (
                      let
                        attrWithFallback = {
                          options = {
                            attr = mkOption {
                              type = str;
                              description = "Attribute to build";
                            };
                            onFail = mkOption {
                              type = listOf (oneOf [
                                str
                                (submodule attrWithFallback)
                              ]);
                              description = "Attributes to build if attr failed";
                            };
                          };
                        };
                      in
                      attrWithFallback
                    ))
                  ]);
                description = "Attributes to build.";
              };
              updateFlake = mkOption {
                default = true;
                type = types.bool;
                description = "Wether to update the flake before building";
              };

              updateScript = mkOption {
                default = "";
                type = types.str;
                description = "Command to update the config";
              };

              failLogInCommitMsg = mkOption {
                default = false;
                type = types.bool;
                description = ''
                  Wether to append a list of the failed `buildAttributes` to the commit message
                '';
              };

              postCommands = mkOption {
                default = "";
                type = types.str;
                description = ''
                  Commands to be executed after the update
                  This can use fail.log, which stores a list of the failed `buildAttributes`, to see which builds failed
                '';
              };

              dates = mkOption {
                type = types.str;
                default = "04:40";
                example = "daily";
                description = ''
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
                description = ''
                  Add a randomized delay before each automatic upgrade.
                  The delay will be chosen between zero and this value.
                  This value must be a time span in the format specified by
                  {manpage}`systemd.time(7)`
                '';
              };

              persistent = mkOption {
                default = false;
                type = types.bool;
                example = true;
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
          }
        )
      );
    };
  };

  config = mkIf (config.services.flakeAutoUpgrade != { }) {

    systemd =
      let
        cfgs = mapAttrs' (
          name: cfg: nameValuePair "flake-auto-upgrade-${name}" cfg
        ) config.services.flakeAutoUpgrade;
      in
      {
        services = mapAttrs' mkServices cfgs;
        timers = mapAttrs' mkTimers cfgs;
      };
  };
}
