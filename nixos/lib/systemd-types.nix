{ lib, systemdUtils, pkgs }:

with systemdUtils.lib;
with systemdUtils.unitOptions;
with lib;

{
  units = with types;
    attrsOf (submodule ({ name, config, ... }: {
      options = concreteUnitOptions;
      config = {
        name = lib.mkDefault name;
        unit = mkDefault (systemdUtils.lib.makeUnit name config);
      };
    }));

  services = with types; attrsOf (submodule [ stage2ServiceOptions unitConfig stage2ServiceConfig ]);
  initrdServices = with types; attrsOf (submodule [ stage1ServiceOptions unitConfig stage1ServiceConfig ]);

  targets = with types; attrsOf (submodule [ stage2CommonUnitOptions unitConfig targetConfig ]);
  initrdTargets = with types; attrsOf (submodule [ stage1CommonUnitOptions unitConfig targetConfig ]);

  sockets = with types; attrsOf (submodule [ stage2SocketOptions unitConfig socketConfig]);
  initrdSockets = with types; attrsOf (submodule [ stage1SocketOptions unitConfig socketConfig ]);

  timers = with types; attrsOf (submodule [ stage2TimerOptions unitConfig timerConfig ]);
  initrdTimers = with types; attrsOf (submodule [ stage1TimerOptions unitConfig timerConfig ]);

  paths = with types; attrsOf (submodule [ stage2PathOptions unitConfig pathConfig ]);
  initrdPaths = with types; attrsOf (submodule [ stage1PathOptions unitConfig pathConfig ]);

  slices = with types; attrsOf (submodule [ stage2SliceOptions unitConfig sliceConfig ]);
  initrdSlices = with types; attrsOf (submodule [ stage1SliceOptions unitConfig sliceConfig ]);

  mounts = with types; listOf (submodule [ stage2MountOptions unitConfig mountConfig ]);
  initrdMounts = with types; listOf (submodule [ stage1MountOptions unitConfig mountConfig ]);

  automounts = with types; listOf (submodule [ stage2AutomountOptions unitConfig automountConfig ]);
  initrdAutomounts = with types; attrsOf (submodule [ stage1AutomountOptions unitConfig automountConfig ]);

  initrdContents = types.attrsOf (types.submodule ({ config, options, name, ... }: {
    options = {
      enable = mkEnableOption (lib.mdDoc "copying of this file and symlinking it") // { default = true; };

      target = mkOption {
        type = types.path;
        description = lib.mdDoc ''
          Path of the symlink.
        '';
        default = name;
      };

      text = mkOption {
        default = null;
        type = types.nullOr types.lines;
        description = lib.mdDoc "Text of the file.";
      };

      source = mkOption {
        type = types.path;
        description = lib.mdDoc "Path of the source file.";
      };
    };

    config = {
      source = mkIf (config.text != null) (
        let name' = "initrd-" + baseNameOf name;
        in mkDerivedConfig options.text (pkgs.writeText name')
      );
    };
  }));
}
