{
  lib,
  systemdUtils,
  pkgs,
}:

let
  inherit (systemdUtils.lib)
    automountConfig
    makeUnit
    unitNameType
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
    coercedTo
    enum
    lines
    listOf
    nullOr
    oneOf
    package
    path
    singleLineStr
    submodule
    ;

  initrdStorePathModule =
    { config, ... }:
    {
      options = {
        enable = (mkEnableOption "copying of this file and symlinking it") // {
          default = true;
        };

        target = mkOption {
          type = nullOr path;
          description = ''
            Path of the symlink.
          '';
          default = null;
        };

        source = mkOption {
          type = path;
          description = "Path of the source file.";
        };

        dlopen = {
          usePriority = mkOption {
            type = enum [
              "required"
              "recommended"
              "suggested"
            ];
            default = "recommended";
            description = ''
              Priority of dlopen ELF notes to include. "required" is
              minimal, "recommended" includes "required", and
              "suggested" includes "recommended".

              See: <https://systemd.io/ELF_DLOPEN_METADATA/>
            '';
          };

          features = mkOption {
            type = listOf singleLineStr;
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
  units = attrsOf (
    lib.types.record {
      declarations = [ ./systemd-unit-options.nix ];
      description = "systemd unit";
      fields = {

        enable = {
          type = lib.types.bool;
          default = true;
          description = ''
            If set to false, this unit will be a symlink to
            /dev/null. This is primarily useful to prevent specific
            template instances
            (e.g. `serial-getty@ttyS0`) from being
            started. Note that `enable=true` does not
            make a unit start by default at boot; if you want that, see
            `wantedBy`.
          '';
        };

        name = {
          type = lib.types.str;
          description = ''
            The name of this systemd unit, including its extension.
            This can be used to refer to this unit from other systemd units.
          '';
        };

        overrideStrategy = {
          type = lib.types.enum [
            "asDropinIfExists"
            "asDropin"
          ];
          default = "asDropinIfExists";
          description = ''
            Defines how unit configuration is provided for systemd:

            `asDropinIfExists` creates a unit file when no unit file is provided by the package
            otherwise it creates a drop-in file named `overrides.conf`.

            `asDropin` creates a drop-in file named `overrides.conf`.
            Mainly needed to define instances for systemd template units (e.g. `systemd-nspawn@mycontainer.service`).

            See also {manpage}`systemd.unit(5)`.
          '';
        };

        requiredBy = {
          type = lib.types.listOf unitNameType;
          default = [ ];
          description = ''
            Units that require (i.e. depend on and need to go down with) this unit.
            As discussed in the `wantedBy` option description this also creates
            `.requires` symlinks automatically.
          '';
        };

        upheldBy = {
          type = lib.types.listOf unitNameType;
          default = [ ];
          description = ''
            Keep this unit running as long as the listed units are running. This is a continuously
            enforced version of wantedBy.
          '';
        };

        wantedBy = {
          type = lib.types.listOf unitNameType;
          default = [ ];
          description = ''
            Units that want (i.e. depend on) this unit. The default method for
            starting a unit by default at boot time is to set this option to
            `["multi-user.target"]` for system services. Likewise for user units
            (`systemd.user.<name>.*`) set it to `["default.target"]` to make a unit
            start by default when the user `<name>` logs on.

            This option creates a `.wants` symlink in the given target that exists
            statelessly without the need for running `systemctl enable`.
            The `[Install]` section described in {manpage}`systemd.unit(5)` however is
            not supported because it is a stateful process that does not fit well
            into the NixOS design.
          '';
        };

        aliases = {
          type = lib.types.listOf unitNameType;
          default = [ ];
          description = "Aliases of that unit.";
        };

        text = {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Text of this systemd unit.";
        };

        unit = {
          type = lib.types.unspecified;
          internal = true;
          description = "The generated unit.";
        };

      };

      finalise =
        { name, self, ... }:
        {
          name = mkDefault name;
          unit = mkDefault (makeUnit name self);
        };
    }
  );

  services = attrsOf (submodule [
    stage2ServiceOptions
    unitConfig
    stage2ServiceConfig
  ]);
  initrdServices = attrsOf (submodule [
    stage1ServiceOptions
    unitConfig
    stage1ServiceConfig
  ]);

  targets = attrsOf (submodule [
    stage2CommonUnitOptions
    unitConfig
    targetConfig
  ]);
  initrdTargets = attrsOf (submodule [
    stage1CommonUnitOptions
    unitConfig
    targetConfig
  ]);

  sockets = attrsOf (submodule [
    stage2SocketOptions
    unitConfig
    socketConfig
  ]);
  initrdSockets = attrsOf (submodule [
    stage1SocketOptions
    unitConfig
    socketConfig
  ]);

  timers = attrsOf (submodule [
    stage2TimerOptions
    unitConfig
    timerConfig
  ]);
  initrdTimers = attrsOf (submodule [
    stage1TimerOptions
    unitConfig
    timerConfig
  ]);

  paths = attrsOf (submodule [
    stage2PathOptions
    unitConfig
    pathConfig
  ]);
  initrdPaths = attrsOf (submodule [
    stage1PathOptions
    unitConfig
    pathConfig
  ]);

  slices = attrsOf (submodule [
    stage2SliceOptions
    unitConfig
    sliceConfig
  ]);
  initrdSlices = attrsOf (submodule [
    stage1SliceOptions
    unitConfig
    sliceConfig
  ]);

  mounts = listOf (submodule [
    stage2MountOptions
    unitConfig
    mountConfig
  ]);
  initrdMounts = listOf (submodule [
    stage1MountOptions
    unitConfig
    mountConfig
  ]);

  automounts = listOf (submodule [
    stage2AutomountOptions
    unitConfig
    automountConfig
  ]);
  initrdAutomounts = attrsOf (submodule [
    stage1AutomountOptions
    unitConfig
    automountConfig
  ]);

  initrdStorePath = listOf (
    coercedTo (oneOf [
      singleLineStr
      package
    ]) (source: { inherit source; }) (submodule initrdStorePathModule)
  );

  initrdContents = attrsOf (
    submodule (
      {
        config,
        options,
        name,
        ...
      }:
      {
        imports = [ initrdStorePathModule ];
        options = {
          text = mkOption {
            default = null;
            type = nullOr lines;
            description = "Text of the file.";
          };
        };

        config = {
          target = mkDefault name;
          source = mkIf (config.text != null) (
            let
              name' = "initrd-" + baseNameOf name;
            in
            mkDerivedConfig options.text (pkgs.writeText name')
          );
        };
      }
    )
  );
}
