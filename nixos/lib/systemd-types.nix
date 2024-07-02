{ lib, systemdUtils, pkgs }:

let
  inherit (systemdUtils.lib)
    automountConfig
    makeUnit
    mountConfig
    pathConfig
    sliceConfig
    socketConfig
    stage1ServiceConfig
    stage2ServiceConfig
    targetConfig
    timerConfig
    unitConfig
    ;

  inherit (systemdUtils.unitOptions)
    concreteUnitOptions
    stage1AutomountOptions
    stage1CommonUnitOptions
    stage1MountOptions
    stage1PathOptions
    stage1ServiceOptions
    stage1SliceOptions
    stage1SocketOptions
    stage1TimerOptions
    stage2AutomountOptions
    stage2CommonUnitOptions
    stage2MountOptions
    stage2PathOptions
    stage2ServiceOptions
    stage2SliceOptions
    stage2SocketOptions
    stage2TimerOptions
    ;

  inherit (lib)
    mkDefault
    mkDerivedConfig
    mkEnableOption
    mkIf
    mkOption
    ;

  inherit (lib.types)
    attrsOf
    lines
    listOf
    nullOr
    path
    submodule
    str
    ;
in

{
  units = attrsOf (submodule ({ name, config, ... }: {
    options = concreteUnitOptions;
    config = {
      name = mkDefault name;
      unit = mkDefault (makeUnit name config);
    };
  }));

  services = attrsOf (submodule [ stage2ServiceOptions unitConfig stage2ServiceConfig ]);
  initrdServices = attrsOf (submodule [ stage1ServiceOptions unitConfig stage1ServiceConfig ]);

  targets = attrsOf (submodule [ stage2CommonUnitOptions unitConfig targetConfig ]);
  initrdTargets = attrsOf (submodule [ stage1CommonUnitOptions unitConfig targetConfig ]);

  sockets = attrsOf (submodule [ stage2SocketOptions unitConfig socketConfig]);
  initrdSockets = attrsOf (submodule [ stage1SocketOptions unitConfig socketConfig ]);

  timers = attrsOf (submodule [ stage2TimerOptions unitConfig timerConfig ]);
  initrdTimers = attrsOf (submodule [ stage1TimerOptions unitConfig timerConfig ]);

  paths = attrsOf (submodule [ stage2PathOptions unitConfig pathConfig ]);
  initrdPaths = attrsOf (submodule [ stage1PathOptions unitConfig pathConfig ]);

  slices = attrsOf (submodule [ stage2SliceOptions unitConfig sliceConfig ]);
  initrdSlices = attrsOf (submodule [ stage1SliceOptions unitConfig sliceConfig ]);

  mounts = listOf (submodule [ stage2MountOptions unitConfig mountConfig ]);
  initrdMounts = listOf (submodule [ stage1MountOptions unitConfig mountConfig ]);

  automounts = listOf (submodule [ stage2AutomountOptions unitConfig automountConfig ]);
  initrdAutomounts = attrsOf (submodule [ stage1AutomountOptions unitConfig automountConfig ]);

  initrdContents = attrsOf (submodule ({ config, options, name, ... }: {
    options = {
      enable = (mkEnableOption "copying of this file and symlinking it") // { default = true; };

      target = mkOption {
        type = path;
        description = ''
          Path of the symlink.
        '';
        default = name;
      };

      text = mkOption {
        default = null;
        type = nullOr lines;
        description = "Text of the file.";
      };

      source = mkOption {
        type = path;
        description = "Path of the source file.";
      };
    };

    config = {
      source = mkIf (config.text != null) (
        let name' = "initrd-" + baseNameOf name;
        in mkDerivedConfig options.text (pkgs.writeText name')
      );
    };
  }));

  tmpfilesSettings = attrsOf (attrsOf (attrsOf (submodule ({ name, config, ... }: {
    options.type = mkOption {
      type = str;
      default = name;
      example = "d";
      description = ''
        The type of operation to perform on the file.

        The type consists of a single letter and optionally one or more
        modifier characters.

        Please see the upstream documentation for the available types and
        more details:
        <https://www.freedesktop.org/software/systemd/man/tmpfiles.d>
      '';
    };
    options.mode = mkOption {
      type = str;
      default = "-";
      example = "0755";
      description = ''
        The file access mode to use when creating this file or directory.
      '';
    };
    options.user = mkOption {
      type = str;
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
      type = str;
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
      type = str;
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
      type = str;
      default = "";
      example = "";
      description = ''
        An argument whose meaning depends on the type of operation.

        Please see the upstream documentation for the meaning of this
        parameter in different situations:
        <https://www.freedesktop.org/software/systemd/man/tmpfiles.d>
      '';
    };
  }))));
}
