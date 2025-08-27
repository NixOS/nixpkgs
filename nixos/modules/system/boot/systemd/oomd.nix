{
  config,
  lib,
  utils,
  ...
}:
let

  cfg = config.systemd.oomd;

in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "systemd" "oomd" "enableUserServices" ]
      [ "systemd" "oomd" "enableUserSlices" ]
    )
    (lib.mkRenamedOptionModule [ "systemd" "oomd" "extraConfig" ] [ "systemd" "oomd" "settings" "OOM" ])
  ];

  options.systemd.oomd = {
    enable = lib.mkEnableOption "the `systemd-oomd` OOM killer" // {
      default = true;
    };

    # Fedora enables the first and third option by default. See the 10-oomd-* files here:
    # https://src.fedoraproject.org/rpms/systemd/tree/806c95e1c70af18f81d499b24cd7acfa4c36ffd6
    enableRootSlice = lib.mkEnableOption "oomd on the root slice (`-.slice`)";
    enableSystemSlice = lib.mkEnableOption "oomd on the system slice (`system.slice`)";
    enableUserSlices = lib.mkEnableOption "oomd on all user slices (`user@.slice`) and all user owned slices";

    settings.OOM = lib.mkOption {
      description = ''
        Settings option for systemd-oomd.
        See {manpage}`oomd.conf(5)` for available options.
      '';
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf utils.systemdUtils.unitOptions.unitOption;
        options.DefaultMemoryPressureDurationSec = lib.mkOption {
          type = lib.types.nonEmptyStr;
          default = "20s";
          description = ''
            Sets the amount of time a unit's control group needs to have exceeded memory pressure limits before systemd-oomd will take action.
            A unit can override this value with ManagedOOMMemoryPressureDurationSec=.
            Memory pressure limits are defined by DefaultMemoryPressureLimit= and ManagedOOMMemoryPressureLimit=.
            Must be set to 0, or at least 1 second. Defaults to 30 seconds when unset or 0.

            See {manpage}`oomd.conf(5)` for more details.

            Set to default to 20s in NixOS following the default set by Fedora.
          '';
        };
      };
      default = { };
      example = {
        DefaultMemoryPressureLimit = "60%";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.additionalUpstreamSystemUnits = [
      "systemd-oomd.service"
      "systemd-oomd.socket"
    ];
    # TODO: Added upstream in upcoming systemd release. Good to drop once we use v258 or later
    systemd.services.systemd-oomd.after = [ "systemd-sysusers.service" ];
    systemd.services.systemd-oomd.wantedBy = [ "multi-user.target" ];

    environment.etc."systemd/oomd.conf".text = utils.systemdUtils.lib.settingsToSections cfg.settings;

    users.users.systemd-oom = {
      description = "systemd-oomd service user";
      group = "systemd-oom";
      isSystemUser = true;
    };
    users.groups.systemd-oom = { };

    systemd.slices."-".sliceConfig = lib.mkIf cfg.enableRootSlice {
      ManagedOOMMemoryPressure = "kill";
      ManagedOOMMemoryPressureLimit = lib.mkDefault "80%";
    };
    systemd.slices."system".sliceConfig = lib.mkIf cfg.enableSystemSlice {
      ManagedOOMMemoryPressure = "kill";
      ManagedOOMMemoryPressureLimit = lib.mkDefault "80%";
    };
    systemd.slices."user".sliceConfig = lib.mkIf cfg.enableUserSlices {
      ManagedOOMMemoryPressure = "kill";
      ManagedOOMMemoryPressureLimit = lib.mkDefault "80%";
    };
    systemd.user.units."slice" = lib.mkIf cfg.enableUserSlices {
      text = ''
        [Slice]
        ManagedOOMMemoryPressure=kill
        ManagedOOMMemoryPressureLimit=80%
      '';
      overrideStrategy = "asDropin";
    };
  };
}
