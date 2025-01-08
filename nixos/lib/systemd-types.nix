{
  lib,
  systemdUtils,
  pkgs,
}:

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

  initrdStorePathModule =
    { config, ... }:
    {
      options = {
        enable = (lib.mkEnableOption "copying of this file and symlinking it") // {
          default = true;
        };

        target = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          description = ''
            Path of the symlink.
          '';
          default = null;
        };

        source = lib.mkOption {
          type = lib.types.path;
          description = "Path of the source file.";
        };

        dlopen = {
          usePriority = lib.mkOption {
            type = lib.types.enum [
              "required"
              "recommended"
              "suggested"
            ];
            default = "recommended";
            description = ''
              Priority of dlopen ELF notes to include. "required" is
              minimal, "recommended" includes "required", and
              "suggested" includes "recommended".

              See: https://systemd.io/ELF_DLOPEN_METADATA/
            '';
          };

          features = lib.mkOption {
            type = lib.types.listOf lib.types.singleLineStr;
            default = [ ];
            description = ''
              Features to enable via dlopen ELF notes. These will be in
              addition to anything included via 'usePriority',
              regardless of their priority.
            '';
          };
        };
      };
    };

in

{
  units = lib.types.attrsOf (
    lib.types.submodule (
      { name, config, ... }:
      {
        options = concreteUnitOptions;
        config = {
          name = lib.mkDefault name;
          unit = lib.mkDefault (makeUnit name config);
        };
      }
    )
  );

  services = lib.types.attrsOf (lib.types.submodule [
    stage2ServiceOptions
    unitConfig
    stage2ServiceConfig
  ]);
  initrdServices = lib.types.attrsOf (lib.types.submodule [
    stage1ServiceOptions
    unitConfig
    stage1ServiceConfig
  ]);

  targets = lib.types.attrsOf (lib.types.submodule [
    stage2CommonUnitOptions
    unitConfig
    targetConfig
  ]);
  initrdTargets = lib.types.attrsOf (lib.types.submodule [
    stage1CommonUnitOptions
    unitConfig
    targetConfig
  ]);

  sockets = lib.types.attrsOf (lib.types.submodule [
    stage2SocketOptions
    unitConfig
    socketConfig
  ]);
  initrdSockets = lib.types.attrsOf (lib.types.submodule [
    stage1SocketOptions
    unitConfig
    socketConfig
  ]);

  timers = lib.types.attrsOf (lib.types.submodule [
    stage2TimerOptions
    unitConfig
    timerConfig
  ]);
  initrdTimers = lib.types.attrsOf (lib.types.submodule [
    stage1TimerOptions
    unitConfig
    timerConfig
  ]);

  paths = lib.types.attrsOf (lib.types.submodule [
    stage2PathOptions
    unitConfig
    pathConfig
  ]);
  initrdPaths = lib.types.attrsOf (lib.types.submodule [
    stage1PathOptions
    unitConfig
    pathConfig
  ]);

  slices = lib.types.attrsOf (lib.types.submodule [
    stage2SliceOptions
    unitConfig
    sliceConfig
  ]);
  initrdSlices = lib.types.attrsOf (lib.types.submodule [
    stage1SliceOptions
    unitConfig
    sliceConfig
  ]);

  mounts = lib.types.listOf (lib.types.submodule [
    stage2MountOptions
    unitConfig
    mountConfig
  ]);
  initrdMounts = lib.types.listOf (lib.types.submodule [
    stage1MountOptions
    unitConfig
    mountConfig
  ]);

  automounts = lib.types.listOf (lib.types.submodule [
    stage2AutomountOptions
    unitConfig
    automountConfig
  ]);
  initrdAutomounts = lib.types.attrsOf (lib.types.submodule [
    stage1AutomountOptions
    unitConfig
    automountConfig
  ]);

  initrdStorePath = lib.types.listOf (
    lib.types.coercedTo (lib.types.oneOf [
      lib.types.singleLineStr
      lib.types.package
    ]) (source: { inherit source; }) (lib.types.submodule initrdStorePathModule)
  );

  initrdContents = lib.types.attrsOf (
    lib.types.submodule (
      {
        config,
        options,
        name,
        ...
      }:
      {
        imports = [ initrdStorePathModule ];
        options = {
          text = lib.mkOption {
            default = null;
            type = lib.types.nullOr lib.types.lines;
            description = "Text of the file.";
          };
        };

        config = {
          target = lib.mkDefault name;
          source = lib.mkIf (config.text != null) (
            let
              name' = "initrd-" + baseNameOf name;
            in
            lib.mkDerivedConfig options.text (pkgs.writeText name')
          );
        };
      }
    )
  );
}
