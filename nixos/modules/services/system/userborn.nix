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

    package = lib.mkPackageOption pkgs "userborn" { };

    passwordFilesLocation = lib.mkOption {
      type = lib.types.str;
      default = if immutableEtc then "/var/lib/nixos" else "/etc";
      defaultText = lib.literalExpression ''if immutableEtc then "/var/lib/nixos" else "/etc"'';
      description = ''
        The location of the original password files.

        If this is not `/etc`, the files are symlinked from this location to `/etc`.

        The primary motivation for this is an immutable `/etc`, where we cannot
        write the files directly to `/etc`.

        However this an also serve other use cases, e.g. when `/etc` is on a `tmpfs`.
      '';
    };

  };

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = !(config.systemd.sysusers.enable && cfg.enable);
        message = "You cannot use systemd-sysusers and Userborn at the same time";
      }
      {
        assertion = config.system.activationScripts.users == "";
        message = "system.activationScripts.users has to be empty to use userborn";
      }
      {
        assertion = immutableEtc -> (cfg.passwordFilesLocation != "/etc");
        message = "When `system.etc.overlay.mutable = false`, `services.userborn.passwordFilesLocation` cannot be set to `/etc`";
      }
    ];

    system.activationScripts.users = lib.mkForce "";
    system.activationScripts.hashes = lib.mkForce "";

    systemd = {

      # Create home directories, do not create /var/empty even if that's a user's
      # home.
      tmpfiles.settings.home-directories = lib.mapAttrs' (
        username: opts:
        lib.nameValuePair (toString opts.home) {
          d = {
            mode = opts.homeMode;
            user = opts.name;
            inherit (opts) group;
          };
        }
      ) (lib.filterAttrs (_username: opts: opts.createHome && opts.home != "/var/empty") userCfg.users);

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
          cfg.passwordFilesLocation
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

          ExecStart = "${lib.getExe cfg.package} ${userbornConfigJson} ${cfg.passwordFilesLocation}";

          ExecStartPre = lib.mkMerge [
            (lib.mkIf (!config.system.etc.overlay.mutable) [
              "${pkgs.coreutils}/bin/mkdir -p ${cfg.passwordFilesLocation}"
            ])

            # Make the source files writable before executing userborn.
            (lib.mkIf (!userCfg.mutableUsers) (
              lib.map (file: "-${pkgs.util-linux}/bin/umount ${cfg.passwordFilesLocation}/${file}") passwordFiles
            ))
          ];

          # Make the source files read-only after userborn has finished.
          ExecStartPost = lib.mkIf (!userCfg.mutableUsers) (
            lib.map (
              file:
              "${pkgs.util-linux}/bin/mount --bind -o ro ${cfg.passwordFilesLocation}/${file} ${cfg.passwordFilesLocation}/${file}"
            ) passwordFiles
          );
        };
      };
    };

    # Statically create the symlinks to passwordFilesLocation when they're not
    # inside /etc because we will not be able to do it at runtime in case of an
    # immutable /etc!
    environment.etc = lib.mkIf (cfg.passwordFilesLocation != "/etc") (
      lib.listToAttrs (
        lib.map (
          file:
          lib.nameValuePair file {
            source = "${cfg.passwordFilesLocation}/${file}";
            mode = "direct-symlink";
          }
        ) passwordFiles
      )
    );
  };

  meta.maintainers = with lib.maintainers; [ nikstur ];

}
