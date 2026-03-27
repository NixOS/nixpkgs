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
    }) (lib.filterAttrs (_: u: u.enable) config.users.users);
  };

  userbornConfigJson = pkgs.writeText "userborn.json" (builtins.toJSON userbornConfig);
  userbornStaticFiles =
    pkgs.runCommand "static-userborn" { }
      "mkdir -p $out; ${lib.getExe cfg.package} ${userbornConfigJson} $out";
  previousConfigPath = "/var/lib/userborn/previous-userborn.json";

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

    static = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to generate the password files at build time and store them directly
        in the system closure, without requiring any services at boot time.

        This is STRICTLY intended for embedded appliance images that only have system
        users with manually managed static user IDs, and CANNOT be used with generation
        updates.

        WARNING: In this mode, you MUST statically manage user IDs yourself, carefully.
        Beware, UID reuse is a serious security issue and it's your responsibility
        to avoid it over the entire lifetime of the system.
      '';
    };

    package = lib.mkPackageOption pkgs "userborn" { };

    passwordFilesLocation = lib.mkOption {
      type = lib.types.str;
      default = if immutableEtc && !cfg.static then "/var/lib/nixos" else "/etc";
      defaultText = lib.literalExpression ''if immutableEtc && !config.services.userborn.static then "/var/lib/nixos" else "/etc"'';
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
        assertion = (immutableEtc && !cfg.static) -> (cfg.passwordFilesLocation != "/etc");
        message = "When `system.etc.overlay.mutable = false` and `services.userborn.static = false`, `services.userborn.passwordFilesLocation` cannot be set to `/etc`";
      }
      {
        assertion = !(cfg.static && config.system.switch.enable);
        message = "You cannot use `services.userborn.static = true` with switchable configurations, it is ONLY indended for appliance images with fully static user IDs";
      }
    ];

    systemd = {

      # Create home directories, do not create /var/empty even if that's a user's
      # home.
      tmpfiles.settings.home-directories =
        lib.mapAttrs'
          (
            username: opts:
            lib.nameValuePair (toString opts.home) {
              d = {
                mode = opts.homeMode;
                user = opts.name;
                inherit (opts) group;
              };
            }
          )
          (
            lib.filterAttrs (
              _username: opts: opts.enable && opts.createHome && opts.home != "/var/empty"
            ) userCfg.users
          );

      services.userborn = lib.mkIf (!cfg.static) {
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
        environment = {
          USERBORN_MUTABLE_USERS = lib.boolToString userCfg.mutableUsers;
          USERBORN_PREVIOUS_CONFIG = lib.mkIf userCfg.mutableUsers previousConfigPath;
        };

        unitConfig = {
          Description = "Manage Users and Groups";
          DefaultDependencies = false;
        };

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          TimeoutSec = "90s";
          StateDirectory = "userborn";

          ExecStart = "${lib.getExe cfg.package} ${userbornConfigJson} ${cfg.passwordFilesLocation}";

          ExecStartPre = lib.mkMerge [
            (lib.mkIf (cfg.passwordFilesLocation != "/etc") [
              "${pkgs.coreutils}/bin/mkdir -p ${cfg.passwordFilesLocation}"
            ])

            # Make the source files writable before executing userborn.
            (lib.mkIf (!userCfg.mutableUsers) (
              lib.map (file: "-${pkgs.util-linux}/bin/umount ${cfg.passwordFilesLocation}/${file}") passwordFiles
            ))
          ];

          ExecStartPost =
            if userCfg.mutableUsers then
              # Store the config somewhere for the next invocation
              [
                "${pkgs.coreutils}/bin/ln -sf ${userbornConfigJson} ${previousConfigPath}"
              ]
            else
              # Make the source files read-only after userborn has finished.
              (lib.map (
                file:
                "${pkgs.util-linux}/bin/mount --bind -o ro ${cfg.passwordFilesLocation}/${file} ${cfg.passwordFilesLocation}/${file}"
              ) passwordFiles);
        };
      };
    };

    environment.etc = lib.mkMerge [
      (lib.mkIf cfg.static (
        # In static mode, statically drop the files into an immutable /etc.
        lib.listToAttrs (
          lib.map (
            file:
            lib.nameValuePair file {
              source = "${userbornStaticFiles}/${file}";
              mode = if file == "shadow" then "0000" else "0644";
            }
          ) passwordFiles
        )
      ))

      (lib.mkIf (!cfg.static && cfg.passwordFilesLocation != "/etc") (
        # Statically create the symlinks to passwordFilesLocation when they're not
        # inside /etc because we will not be able to do it at runtime in case of a
        # (non-static) immutable /etc!
        lib.listToAttrs (
          lib.map (
            file:
            lib.nameValuePair file {
              source = "${cfg.passwordFilesLocation}/${file}";
              mode = "direct-symlink";
            }
          ) passwordFiles
        )
      ))
    ];
  };

  meta.maintainers = with lib.maintainers; [ nikstur ];

}
