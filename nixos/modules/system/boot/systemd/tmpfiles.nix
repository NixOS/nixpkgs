{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.systemd.tmpfiles;
  initrdCfg = config.boot.initrd.systemd.tmpfiles;
  systemd = config.systemd.package;

  attrsWith' = placeholder: elemType: types.attrsWith {
    inherit elemType placeholder;
  };

  settingsOption = {
    description = ''
      Declare systemd-tmpfiles rules to create, delete, and clean up volatile
      and temporary files and directories.

      Even though the service is called `*tmp*files` you can also create
      persistent files.
    '';
    example = {
      "10-mypackage" = {
        "/var/lib/my-service/statefolder".d = {
          mode = "0755";
          user = "root";
          group = "root";
        };
      };
    };
    default = {};
    type = attrsWith' "config-name" (attrsWith' "path" (attrsWith' "tmpfiles-type" (types.submodule ({ name, config, ... }: {
      options.type = mkOption {
        type = types.str;
        default = name;
        defaultText = "‹tmpfiles-type›";
        example = "d";
        description = ''
          The type of operation to perform on the file.

          The type consists of a single letter and optionally one or more
          modifier characters.

          Please see the upstream documentation for the available types and
          more details:
          {manpage}`tmpfiles.d(5)`
        '';
      };
      options.mode = mkOption {
        type = types.str;
        default = "-";
        example = "0755";
        description = ''
          The file access mode to use when creating this file or directory.
        '';
      };
      options.user = mkOption {
        type = types.str;
        default = "-";
        example = "root";
        description = ''
          The user of the file.

          This may either be a numeric ID or a user/group name.

          If omitted or when set to `"-"`, the user and group of the user who
          invokes systemd-tmpfiles is used.
        '';
      };
      options.group = mkOption {
        type = types.str;
        default = "-";
        example = "root";
        description = ''
          The group of the file.

          This may either be a numeric ID or a user/group name.

          If omitted or when set to `"-"`, the user and group of the user who
          invokes systemd-tmpfiles is used.
        '';
      };
      options.age = mkOption {
        type = types.str;
        default = "-";
        example = "10d";
        description = ''
          Delete a file when it reaches a certain age.

          If a file or directory is older than the current time minus the age
          field, it is deleted.

          If set to `"-"` no automatic clean-up is done.
        '';
      };
      options.argument = mkOption {
        type = types.str;
        default = "";
        example = "";
        description = ''
          An argument whose meaning depends on the type of operation.

          Please see the upstream documentation for the meaning of this
          parameter in different situations:
          {manpage}`tmpfiles.d(5)`
        '';
      };
    }))));
  };

  # generates a single entry for a tmpfiles.d rule
  settingsEntryToRule = path: entry: ''
    '${entry.type}' '${path}' '${entry.mode}' '${entry.user}' '${entry.group}' '${entry.age}' ${entry.argument}
  '';

  # generates a list of tmpfiles.d rules from the attrs (paths) under tmpfiles.settings.<name>
  pathsToRules = mapAttrsToList (path: types:
    concatStrings (
      mapAttrsToList (_type: settingsEntryToRule path) types
    )
  );

  mkRuleFileContent = paths: concatStrings (pathsToRules paths);
in
{
  options = {
    systemd.tmpfiles.rules = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "d /tmp 1777 root root 10d" ];
      description = ''
        Rules for creation, deletion and cleaning of volatile and temporary files
        automatically. See
        {manpage}`tmpfiles.d(5)`
        for the exact format.
      '';
    };

    systemd.tmpfiles.settings = mkOption settingsOption;

    boot.initrd.systemd.tmpfiles.settings = mkOption (settingsOption // {
      description = ''
        Similar to {option}`systemd.tmpfiles.settings` but the rules are
        only applied by systemd-tmpfiles before `initrd-switch-root.target`.

        See {manpage}`bootup(7)`.
      '';
    });

    systemd.tmpfiles.packages = mkOption {
      type = types.listOf types.package;
      default = [];
      example = literalExpression "[ pkgs.lvm2 ]";
      apply = map getLib;
      description = ''
        List of packages containing {command}`systemd-tmpfiles` rules.

        All files ending in .conf found in
        {file}`«pkg»/lib/tmpfiles.d`
        will be included.
        If this folder does not exist or does not contain any files an error will be returned instead.

        If a {file}`lib` output is available, rules are searched there and only there.
        If there is no {file}`lib` output it will fall back to {file}`out`
        and if that does not exist either, the default output will be used.
      '';
    };
  };

  config = {
    warnings =
      let
        paths = lib.filter (path:
          path != null && lib.hasPrefix "/etc/tmpfiles.d/" path
        ) (map (path: path.target) config.boot.initrd.systemd.storePaths);
      in
      lib.optional (lib.length paths > 0) (lib.concatStringsSep " " [
        "Files inside /etc/tmpfiles.d in the initrd need to be created with"
        "boot.initrd.systemd.tmpfiles.settings."
        "Creating them by hand using boot.initrd.systemd.contents or"
        "boot.initrd.systemd.storePaths will lead to errors in the future."
        "Found these problematic files: ${lib.concatStringsSep ", " paths}"
      ]);

    systemd.additionalUpstreamSystemUnits = [
      "systemd-tmpfiles-clean.service"
      "systemd-tmpfiles-clean.timer"
      "systemd-tmpfiles-setup-dev-early.service"
      "systemd-tmpfiles-setup-dev.service"
      "systemd-tmpfiles-setup.service"
    ];

    systemd.additionalUpstreamUserUnits = [
      "systemd-tmpfiles-clean.service"
      "systemd-tmpfiles-clean.timer"
      "systemd-tmpfiles-setup.service"
    ];

    # Allow systemd-tmpfiles to be restarted by switch-to-configuration. This
    # service is not pulled into the normal boot process. It only exists for
    # switch-to-configuration.
    #
    # This needs to be a separate unit because it does not execute
    # systemd-tmpfiles with `--boot` as that is supposed to only be executed
    # once at boot time.
    #
    # Keep this aligned with the upstream `systemd-tmpfiles-setup.service` unit.
    systemd.services."systemd-tmpfiles-resetup" = {
      description = "Re-setup tmpfiles on a system that is already running.";

      requiredBy = [ "sysinit-reactivation.target" ];
      after = [ "local-fs.target" "systemd-sysusers.service" "systemd-journald.service" ];
      before = [ "sysinit-reactivation.target" "shutdown.target" ];
      conflicts = [ "shutdown.target" ];
      restartTriggers = [ config.environment.etc."tmpfiles.d".source ];

      unitConfig.DefaultDependencies = false;

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "systemd-tmpfiles --create --remove --exclude-prefix=/dev";
        SuccessExitStatus = "DATAERR CANTCREAT";
        ImportCredential = [
          "tmpfiles.*"
          "loging.motd"
          "login.issue"
          "network.hosts"
          "ssh.authorized_keys.root"
        ];
      };
    };

    environment.etc = {
      "tmpfiles.d".source = (pkgs.symlinkJoin {
        name = "tmpfiles.d";
        paths = map (p: p + "/lib/tmpfiles.d") cfg.packages;
        postBuild = ''
          for i in $(cat $pathsPath); do
            (test -d "$i" && test $(ls "$i"/*.conf | wc -l) -ge 1) || (
              echo "ERROR: The path '$i' from systemd.tmpfiles.packages contains no *.conf files."
              exit 1
            )
          done
        '' + concatMapStrings (name: optionalString (hasPrefix "tmpfiles.d/" name) ''
          rm -f $out/${removePrefix "tmpfiles.d/" name}
        '') config.system.build.etc.passthru.targets;
      }) + "/*";
      "mtab" = {
        mode = "direct-symlink";
        source = "/proc/mounts";
      };
    };

    systemd.tmpfiles.packages = [
      # Default tmpfiles rules provided by systemd
      (pkgs.runCommand "systemd-default-tmpfiles" {} ''
        mkdir -p $out/lib/tmpfiles.d
        cd $out/lib/tmpfiles.d

        ln -s "${systemd}/example/tmpfiles.d/home.conf"
        ln -s "${systemd}/example/tmpfiles.d/journal-nocow.conf"
        ln -s "${systemd}/example/tmpfiles.d/portables.conf"
        ln -s "${systemd}/example/tmpfiles.d/static-nodes-permissions.conf"
        ln -s "${systemd}/example/tmpfiles.d/systemd.conf"
        ln -s "${systemd}/example/tmpfiles.d/systemd-nologin.conf"
        ln -s "${systemd}/example/tmpfiles.d/systemd-nspawn.conf"
        ln -s "${systemd}/example/tmpfiles.d/systemd-tmp.conf"
        ln -s "${systemd}/example/tmpfiles.d/tmp.conf"
        ln -s "${systemd}/example/tmpfiles.d/var.conf"
        ln -s "${systemd}/example/tmpfiles.d/x11.conf"
      '')
      # User-specified tmpfiles rules
      (pkgs.writeTextFile {
        name = "nixos-tmpfiles.d";
        destination = "/lib/tmpfiles.d/00-nixos.conf";
        text = ''
          # This file is created automatically and should not be modified.
          # Please change the option ‘systemd.tmpfiles.rules’ instead.

          ${concatStringsSep "\n" cfg.rules}
        '';
      })
    ] ++ (mapAttrsToList (name: paths:
      pkgs.writeTextDir "lib/tmpfiles.d/${name}.conf" (mkRuleFileContent paths)
    ) cfg.settings);

    systemd.tmpfiles.rules = [
      "d  /run/lock                          0755 root root - -"
      "d  /var/db                            0755 root root - -"
      "L  /var/lock                          -    -    -    - ../run/lock"
    ] ++ lib.optionals config.nix.enable [
      "d  /nix/var                           0755 root root - -"
      "L+ /nix/var/nix/gcroots/booted-system 0755 root root - /run/booted-system"
    ]
    # Boot-time cleanup
    ++ [
      "R! /etc/group.lock                    -    -    -    - -"
      "R! /etc/passwd.lock                   -    -    -    - -"
      "R! /etc/shadow.lock                   -    -    -    - -"
    ] ++ lib.optionals config.nix.enable [
      "R! /nix/var/nix/gcroots/tmp           -    -    -    - -"
      "R! /nix/var/nix/temproots             -    -    -    - -"
    ];

    boot.initrd.systemd = {
      additionalUpstreamUnits = [
        "systemd-tmpfiles-setup-dev-early.service"
        "systemd-tmpfiles-setup-dev.service"
        "systemd-tmpfiles-setup.service"
      ];

      # override to exclude the prefix /sysroot, because it is not necessarily set up when the unit starts
      services.systemd-tmpfiles-setup.serviceConfig = {
        ExecStart = [
          ""
          "systemd-tmpfiles --create --remove --boot --exclude-prefix=/dev --exclude-prefix=/sysroot"
        ];
      };

      # sets up files under the prefix /sysroot, after the hierarchy is available and before nixos activation
      services.systemd-tmpfiles-setup-sysroot = {
        description = "Create Volatile Files and Directories in the Real Root";
        after = [ "initrd-fs.target" ];
        before = [
          "initrd.target"
          "shutdown.target" "initrd-switch-root.target"
        ];
        conflicts = [ "shutdown.target" "initrd-switch-root.target" ];
        wantedBy = [ "initrd.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "systemd-tmpfiles --create --remove --boot --exclude-prefix=/dev --prefix=/sysroot";
          SuccessExitStatus = [ "DATAERR CANTCREAT" ];
          ImportCredential = [
            "tmpfiles.*"
            "login.motd"
            "login.issue"
            "network.hosts"
            "ssh.authorized_keys.root"
          ];
        };
        unitConfig = {
          DefaultDependencies = false;
          RefuseManualStop = true;
        };

      };

      contents."/etc/tmpfiles.d" = mkIf (initrdCfg.settings != { }) {
        source = pkgs.linkFarm "initrd-tmpfiles.d" (
          mapAttrsToList
            (name: paths: {
              name = "${name}.conf";
              path = pkgs.writeText "${name}.conf" (mkRuleFileContent paths);
            }
            )
            initrdCfg.settings);
      };
    };
  };
}
