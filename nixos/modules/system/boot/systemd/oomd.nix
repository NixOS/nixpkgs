{ config, lib, ... }: let

  cfg = config.systemd.oomd;

in {
  options.systemd.oomd = {
    enable = lib.mkEnableOption "the systemd-oomd OOM killer" // { default = true; };

    # Fedora enables the first and third option by default. See the 10-oomd-* files here:
    # https://src.fedoraproject.org/rpms/systemd/tree/acb90c49c42276b06375a66c73673ac351025597
    enableRootSlice = lib.mkEnableOption "oomd on the root slice (-.slice)";
    enableSystemSlice = lib.mkEnableOption "oomd on the system slice (system.slice)";
    enableUserServices = lib.mkEnableOption "oomd on all user services (user@.service)";

    extraConfig = lib.mkOption {
      type = with lib.types; attrsOf (oneOf [ str int bool ]);
      default = {};
      example = lib.literalExpression ''{ DefaultMemoryPressureDurationSec = "20s"; }'';
      description = ''
        Extra config options for systemd-oomd. See man oomd.conf
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
      ManagedOOMSwap = "kill";
    };
    systemd.slices."system".sliceConfig = lib.mkIf cfg.enableSystemSlice {
      ManagedOOMSwap = "kill";
    };
    systemd.services."user@".serviceConfig = lib.mkIf cfg.enableUserServices {
      ManagedOOMMemoryPressure = "kill";
      ManagedOOMMemoryPressureLimit = "50%";
    };
  };
}
