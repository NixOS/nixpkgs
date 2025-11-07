{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let

  cfg = config.systemd.sysusers;
  userCfg = config.users;

  systemUsers = lib.filterAttrs (_username: opts: opts.enable && !opts.isNormalUser) userCfg.users;

  sysusersConfig = pkgs.writeTextDir "00-nixos.conf" ''
    # Type Name ID GECOS Home directory Shell

    # Users
    ${lib.concatLines (
      lib.mapAttrsToList (
        username: opts:
        let
          uid = if opts.uid == null then "/var/lib/nixos/uid/${username}" else toString opts.uid;
        in
        ''u ${username} ${uid}:${opts.group} "${opts.description}" ${opts.home} ${utils.toShellPath opts.shell}''
      ) systemUsers
    )}

    # Groups
    ${lib.concatLines (
      lib.mapAttrsToList (
        groupname: opts:
        ''g ${groupname} ${
          if opts.gid == null then "/var/lib/nixos/gid/${groupname}" else toString opts.gid
        }''
      ) userCfg.groups
    )}

    # Group membership
    ${lib.concatStrings (
      lib.mapAttrsToList (
        groupname: opts: (lib.concatMapStrings (username: "m ${username} ${groupname}\n")) opts.members
      ) userCfg.groups
    )}
  '';

  immutableEtc = config.system.etc.overlay.enable && !config.system.etc.overlay.mutable;
  # The location of the password files when using an immutable /etc.
  immutablePasswordFilesLocation = "/var/lib/nixos/etc";
  passwordFilesLocation = if immutableEtc then immutablePasswordFilesLocation else "/etc";
  # The filenames created by systemd-sysusers.
  passwordFiles = [
    "passwd"
    "group"
    "shadow"
    "gshadow"
  ];

in

{

  options = {

    # This module doesn't set it's own user options but reuses the ones from
    # users-groups.nix

    systemd.sysusers = {
      enable = lib.mkEnableOption "systemd-sysusers" // {
        description = ''
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
    ]
    ++ (lib.mapAttrsToList (username: opts: {
      assertion = opts.enable -> !opts.isNormalUser;
      message = "${username} is a normal user. systemd-sysusers doesn't create normal users, only system users.";
    }) userCfg.users)
    ++ lib.mapAttrsToList (username: opts: {
      assertion =
        (opts.password == opts.initialPassword || opts.password == null)
        && (opts.hashedPassword == opts.initialHashedPassword || opts.hashedPassword == null);
      message = "user '${username}' uses password or hashedPassword. systemd-sysupdate only supports initial passwords. It'll never update your passwords.";
    }) systemUsers;

    systemd = {

      # Create home directories, do not create /var/empty even if that's a user's
      # home.
      tmpfiles.settings.home-directories = lib.mapAttrs' (
        username: opts:
        lib.nameValuePair opts.home {
          d = {
            mode = opts.homeMode;
            user = username;
            group = opts.group;
          };
        }
      ) (lib.filterAttrs (_username: opts: opts.home != "/var/empty") systemUsers);

      # Create uid/gid marker files for those without an explicit id
      tmpfiles.settings.nixos-uid = lib.mapAttrs' (
        username: opts:
        lib.nameValuePair "/var/lib/nixos/uid/${username}" {
          f = {
            user = username;
          };
        }
      ) (lib.filterAttrs (_username: opts: opts.uid == null) systemUsers);

      tmpfiles.settings.nixos-gid = lib.mapAttrs' (
        groupname: opts:
        lib.nameValuePair "/var/lib/nixos/gid/${groupname}" {
          f = {
            group = groupname;
          };
        }
      ) (lib.filterAttrs (_groupname: opts: opts.gid == null) userCfg.groups);

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
          # When we have an immutable /etc we cannot write the files directly
          # to /etc so we write it to a different directory and symlink them
          # into /etc.
          #
          # We need to explicitly list the config file, otherwise
          # systemd-sysusers cannot find it when we also pass another flag.
          ExecStart = lib.mkIf immutableEtc [
            ""
            "${config.systemd.package}/bin/systemd-sysusers --root ${builtins.dirOf immutablePasswordFilesLocation} /etc/sysusers.d/00-nixos.conf"
          ];

          # Make the source files writable before executing sysusers.
          ExecStartPre = lib.mkIf (!userCfg.mutableUsers) (
            lib.map (file: "-${pkgs.util-linux}/bin/umount ${passwordFilesLocation}/${file}") passwordFiles
          );
          # Make the source files read-only after sysusers has finished.
          ExecStartPost = lib.mkIf (!userCfg.mutableUsers) (
            lib.map (
              file:
              "${pkgs.util-linux}/bin/mount --bind -o ro ${passwordFilesLocation}/${file} ${passwordFilesLocation}/${file}"
            ) passwordFiles
          );

          LoadCredential = lib.mapAttrsToList (
            username: opts: "passwd.hashed-password.${username}:${opts.hashedPasswordFile}"
          ) (lib.filterAttrs (_username: opts: opts.hashedPasswordFile != null) systemUsers);
          SetCredential =
            (lib.mapAttrsToList (
              username: opts: "passwd.hashed-password.${username}:${opts.initialHashedPassword}"
            ) (lib.filterAttrs (_username: opts: opts.initialHashedPassword != null) systemUsers))
            ++ (lib.mapAttrsToList (
              username: opts: "passwd.plaintext-password.${username}:${opts.initialPassword}"
            ) (lib.filterAttrs (_username: opts: opts.initialPassword != null) systemUsers));
        };
      };

    };

    environment.etc = lib.mkMerge [
      {
        "sysusers.d".source = sysusersConfig;
      }

      # Statically create the symlinks to immutablePasswordFilesLocation when
      # using an immutable /etc because we will not be able to do it at
      # runtime!
      (lib.mkIf immutableEtc (
        lib.listToAttrs (
          lib.map (
            file:
            lib.nameValuePair file {
              source = "${immutablePasswordFilesLocation}/${file}";
              mode = "direct-symlink";
            }
          ) passwordFiles
        )
      ))
    ];
  };

  meta.maintainers = with lib.maintainers; [ nikstur ];

}
