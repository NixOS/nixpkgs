{
  utils,
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.userborn;
  userCfg = config.users;

  userbornConfig = {
    groups = lib.mapAttrsToList (username: opts: {
      inherit (opts) name gid members;
    }) config.users.groups;

    users = lib.mapAttrsToList (username: opts: {
      inherit (opts)
        name
        uid
        group
        description
        home
        password
        hashedPassword
        hashedPasswordFile
        initialPassword
        initialHashedPassword
        ;
      isNormal = opts.isNormalUser;
      shell = utils.toShellPath opts.shell;
    }) config.users.users;
  };

  userbornConfigJson = pkgs.writeText "userborn.json" (builtins.toJSON userbornConfig);

  immutableEtc = config.system.etc.overlay.enable && !config.system.etc.overlay.mutable;
  passwordFilesLocation = if immutableEtc then cfg.immutablePasswordFilesLocation else "/etc";
  # The filenames created by userborn.
  passwordFiles = [
    "group"
    "passwd"
    "shadow"
  ];

in
{

  options.services.userborn = {

    enable = lib.mkEnableOption "userborn";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.userborn;
      defaultText = "pkgs.userborn";
      description = "The userborn package";
    };

    immutablePasswordFilesLocation = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/nixos";
      description = "The location of the original password files when using an immutable /etc";
    };

  };

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = config.system.activationScripts.users == "";
        message = "system.activationScripts.users has to be empty to use userborn";
      }
    ];

    system.activationScripts.users = lib.mkForce "";
    system.activationScripts.hashes = lib.mkForce "";

    systemd = {

      # Create home directories, do not create /var/empty even if that's a user's
      # home.
      tmpfiles.settings.home-directories = lib.mapAttrs' (
        username: opts:
        lib.nameValuePair opts.home {
          d = {
            mode = opts.homeMode;
            user = username;
            inherit (opts) group;
          };
        }
      ) (lib.filterAttrs (_username: opts: opts.home != "/var/empty") userCfg.users);

      services.userborn = {
        wantedBy = [ "sysinit.target" ];
        requiredBy = [ "sysinit-reactivation.target" ];
        after = [
          "systemd-remount-fs.service"
          "systemd-tmpfiles-setup-dev-early.service"
        ];
        before = [
          "systemd-tmpfiles-setup-dev.service"
          "sysinit.target"
          "shutdown.target"
          "sysinit-reactivation.target"
        ];
        conflicts = [ "shutdown.target" ];
        restartTriggers = [
          userbornConfigJson
          passwordFilesLocation
        ];
        # This way we don't have to re-declare all the dependencies to other
        # services again.
        aliases = [ "systemd-sysusers.service" ];

        unitConfig = {
          Description = "Manage Users and Groups";
          DefaultDependencies = false;
        };

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          TimeoutSec = "90s";

          # When we have an immutable /etc we cannot write the files directly
          # to /etc so we write it to a different directory and symlink them
          # into /etc.
          ExecStart = "${cfg.package}/bin/userborn ${userbornConfigJson} ${passwordFilesLocation}";

          ExecStartPre = lib.mkMerge [
            (lib.mkIf (!config.system.etc.overlay.mutable) [
              "${pkgs.coreutils}/bin/mkdir -p ${passwordFilesLocation}"
            ])

            # Make the source files writable before executing userborn.
            (lib.mkIf (!userCfg.mutableUsers) (
              lib.map (file: "-${pkgs.util-linux}/bin/umount ${passwordFilesLocation}/${file}") passwordFiles
            ))
          ];

          # Make the source files read-only after userborn has finished.
          ExecStartPost = lib.mkIf (!userCfg.mutableUsers) (
            lib.map (
              file:
              "${pkgs.util-linux}/bin/mount --bind -o ro ${passwordFilesLocation}/${file} ${passwordFilesLocation}/${file}"
            ) passwordFiles
          );
        };
      };
    };

    # Statically create the symlinks to immutablePasswordFilesLocation when
    # using an immutable /etc because we will not be able to do it at
    # runtime!
    environment.etc = lib.mkIf immutableEtc (
      lib.listToAttrs (
        lib.map (
          file:
          lib.nameValuePair file {
            source = "${cfg.immutablePasswordFilesLocation}/${file}";
            mode = "direct-symlink";
          }
        ) passwordFiles
      )
    );
  };

  meta.maintainers = with lib.maintainers; [ nikstur ];

}
