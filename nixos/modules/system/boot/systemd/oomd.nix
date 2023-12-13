{ config, lib, utils, ... }: let

  cfg = config.systemd.oomd;

  sliceConfig = {
    ManagedOOMMemoryPressure = "kill";
    ManagedOOMMemoryPressureLimit = "80%";
  };

in {
  imports = [
    (lib.mkRenamedOptionModule [ "systemd" "oomd" "enableUserServices" ] [ "systemd" "oomd" "enableUserSlices" ])
  ];

  options.systemd.oomd = {
    enable = lib.mkEnableOption (lib.mdDoc "the `systemd-oomd` OOM killer") // { default = true; };

    # Same defaults as Fedora, see the 10-oomd-* files here:
    # https://src.fedoraproject.org/rpms/systemd/tree/1320fc300948e7c12d16ea8dd4e0fae3fd821d54
    enableRootSlice = lib.mkEnableOption (lib.mdDoc "oomd on the root slice (`-.slice`)");
    enableSystemSlice = lib.mkEnableOption (lib.mdDoc "oomd on the system slice") // { default = true; };
    enableUserSlices = lib.mkEnableOption (lib.mdDoc ''
      oomd on all user slices.

      As `systemd-oomd` acts on a per-cgroup level, applications will need
      to spawn processes into separate cgroups (e.g. with `systemd-run`)
      or use a desktop environment (e.g. GNOME, KDE) that does this for them'');

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

    systemd.slices."-".sliceConfig = lib.mkIf cfg.enableRootSlice sliceConfig;
    systemd.slices."system".sliceConfig = lib.mkIf cfg.enableSystemSlice sliceConfig;
    systemd.user.units."slice" = lib.mkIf cfg.enableUserSlices {
      text = ''
        [Slice]
        ${utils.systemdUtils.lib.attrsToSection sliceConfig}
      '';
      overrideStrategy = "asDropin";
    };
  };
}
