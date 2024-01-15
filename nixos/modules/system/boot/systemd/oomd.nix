{ config, lib, ... }: let

  cfg = config.systemd.oomd;

in {
  imports = [
    (lib.mkRenamedOptionModule [ "systemd" "oomd" "enableUserServices" ] [ "systemd" "oomd" "enableUserSlices" ])
  ];

  options.systemd.oomd = {
    enable = lib.mkEnableOption (lib.mdDoc "the `systemd-oomd` OOM killer") // { default = true; };

    # Fedora enables the first and third option by default. See the 10-oomd-* files here:
    # https://src.fedoraproject.org/rpms/systemd/tree/806c95e1c70af18f81d499b24cd7acfa4c36ffd6
    enableRootSlice = lib.mkEnableOption (lib.mdDoc "oomd on the root slice (`-.slice`)");
    enableSystemSlice = lib.mkEnableOption (lib.mdDoc "oomd on the system slice (`system.slice`)");
    enableUserSlices = lib.mkEnableOption (lib.mdDoc "oomd on all user slices (`user@.slice`) and all user owned slices");

    extraConfig = lib.mkOption {
      type = with lib.types; attrsOf (oneOf [ str int bool ]);
      default = {};
      example = lib.literalExpression ''{ DefaultMemoryPressureDurationSec = "20s"; }'';
      description = lib.mdDoc ''
        Extra config options for `systemd-oomd`. See {command}`man oomd.conf`
        for available options.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.additionalUpstreamSystemUnits = [
      "systemd-oomd.service"
      "systemd-oomd.socket"
    ];
    systemd.services.systemd-oomd.wantedBy = [ "multi-user.target" ];

    environment.etc."systemd/oomd.conf".text = lib.generators.toINI {} {
      OOM = cfg.extraConfig;
    };

    systemd.oomd.extraConfig.DefaultMemoryPressureDurationSec = lib.mkDefault "20s"; # Fedora default

    users.users.systemd-oom = {
      description = "systemd-oomd service user";
      group = "systemd-oom";
      isSystemUser = true;
    };
    users.groups.systemd-oom = { };

    systemd.slices."-".sliceConfig = lib.mkIf cfg.enableRootSlice {
      ManagedOOMMemoryPressure = "kill";
      ManagedOOMMemoryPressureLimit = "80%";
    };
    systemd.slices."system".sliceConfig = lib.mkIf cfg.enableSystemSlice {
      ManagedOOMMemoryPressure = "kill";
      ManagedOOMMemoryPressureLimit = "80%";
    };
    systemd.slices."user-".sliceConfig = lib.mkIf cfg.enableUserSlices {
      ManagedOOMMemoryPressure = "kill";
      ManagedOOMMemoryPressureLimit = "80%";
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
