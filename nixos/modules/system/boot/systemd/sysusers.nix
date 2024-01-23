{ config, lib, pkgs, utils, ... }:

let

  cfg = config.systemd.sysusers;
  userCfg = config.users;

  sysusersConfig = pkgs.writeTextDir "00-nixos.conf" ''
    # Type Name ID GECOS Home directory Shell

    # Users
    ${lib.concatLines (lib.mapAttrsToList
      (username: opts:
        let
          uid = if opts.uid == null then "-" else toString opts.uid;
        in
          ''u ${username} ${uid}:${opts.group} "${opts.description}" ${opts.home} ${utils.toShellPath opts.shell}''
      )
      userCfg.users)
    }

    # Groups
    ${lib.concatLines (lib.mapAttrsToList
      (groupname: opts: ''g ${groupname} ${if opts.gid == null then "-" else toString opts.gid}'') userCfg.groups)
    }

    # Group membership
    ${lib.concatStrings (lib.mapAttrsToList
      (groupname: opts: (lib.concatMapStrings (username: "m ${username} ${groupname}\n")) opts.members ) userCfg.groups)
    }
  '';

  staticSysusersCredentials = pkgs.runCommand "static-sysusers-credentials" { } ''
    mkdir $out; cd $out
    ${lib.concatLines (
      (lib.mapAttrsToList
        (username: opts: "echo -n '${opts.initialHashedPassword}' > 'passwd.hashed-password.${username}'")
        (lib.filterAttrs (_username: opts: opts.initialHashedPassword != null) userCfg.users))
        ++
      (lib.mapAttrsToList
        (username: opts: "echo -n '${opts.initialPassword}' > 'passwd.plaintext-password.${username}'")
        (lib.filterAttrs (_username: opts: opts.initialPassword != null) userCfg.users))
        ++
      (lib.mapAttrsToList
        (username: opts: "cat '${opts.hashedPasswordFile}' > 'passwd.hashed-password.${username}'")
        (lib.filterAttrs (_username: opts: opts.hashedPasswordFile != null) userCfg.users))
      )
    }
  '';

  staticSysusers = pkgs.runCommand "static-sysusers"
    {
      nativeBuildInputs = [ pkgs.systemd ];
    } ''
    mkdir $out
    export CREDENTIALS_DIRECTORY=${staticSysusersCredentials}
    systemd-sysusers --root $out ${sysusersConfig}/00-nixos.conf
  '';

in

{

  options = {

    # This module doesn't set it's own user options but reuses the ones from
    # users-groups.nix

    systemd.sysusers = {
      enable = lib.mkEnableOption (lib.mdDoc "systemd-sysusers") // {
        description = lib.mdDoc ''
          If enabled, users are created with systemd-sysusers instead of with
          the custom `update-users-groups.pl` script.

          Note: This is experimental.
        '';
      };
    };

  };

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = config.system.activationScripts.users == "";
        message = "system.activationScripts.users has to be empty to use systemd-sysusers";
      }
      {
        assertion = config.users.mutableUsers -> config.system.etc.overlay.enable;
        message = "config.users.mutableUsers requires config.system.etc.overlay.enable.";
      }
    ];

    systemd = lib.mkMerge [
      ({

        # Create home directories, do not create /var/empty even if that's a user's
        # home.
        tmpfiles.settings.home-directories = lib.mapAttrs'
          (username: opts: lib.nameValuePair opts.home {
            d = {
              mode = opts.homeMode;
              user = username;
              group = opts.group;
            };
          })
          (lib.filterAttrs (_username: opts: opts.home != "/var/empty") userCfg.users);
      })

      (lib.mkIf config.users.mutableUsers {
        additionalUpstreamSystemUnits = [
          "systemd-sysusers.service"
        ];

        services.systemd-sysusers = {
          # Enable switch-to-configuration to restart the service.
          unitConfig.ConditionNeedsUpdate = [ "" ];
          requiredBy = [ "sysinit-reactivation.target" ];
          before = [ "sysinit-reactivation.target" ];
          restartTriggers = [ "${config.environment.etc."sysusers.d".source}" ];

          serviceConfig = {
            LoadCredential = lib.mapAttrsToList
              (username: opts: "passwd.hashed-password.${username}:${opts.hashedPasswordFile}")
              (lib.filterAttrs (_username: opts: opts.hashedPasswordFile != null) userCfg.users);
            SetCredential = (lib.mapAttrsToList
              (username: opts: "passwd.hashed-password.${username}:${opts.initialHashedPassword}")
              (lib.filterAttrs (_username: opts: opts.initialHashedPassword != null) userCfg.users))
            ++
            (lib.mapAttrsToList
              (username: opts: "passwd.plaintext-password.${username}:${opts.initialPassword}")
              (lib.filterAttrs (_username: opts: opts.initialPassword != null) userCfg.users))
            ;
          };
        };
      })
    ];

    environment.etc = lib.mkMerge [
      (lib.mkIf (!userCfg.mutableUsers) {
        "passwd" = {
          source = "${staticSysusers}/etc/passwd";
          mode = "0644";
        };
        "group" = {
          source = "${staticSysusers}/etc/group";
          mode = "0644";
        };
        "shadow" = {
          source = "${staticSysusers}/etc/shadow";
          mode = "0000";
        };
        "gshadow" = {
          source = "${staticSysusers}/etc/gshadow";
          mode = "0000";
        };
      })

      (lib.mkIf userCfg.mutableUsers {
        "sysusers.d".source = sysusersConfig;
      })
    ];

  };

  meta.maintainers = with lib.maintainers; [ nikstur ];

}
