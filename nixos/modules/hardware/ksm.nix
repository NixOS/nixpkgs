{ config, lib, ... }:

with lib;

let
  cfg = config.hardware.ksm;

in {
  imports = [
    (mkRenamedOptionModule [ "hardware" "enableKSM" ] [ "hardware" "ksm" "enable" ])
  ];

  options.hardware.ksm = {
    enable = mkEnableOption "Kernel Samepage Merging";
    sleep = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = ''
        How many milliseconds ksmd should sleep between scans.
        Setting it to <literal>null</literal> uses the kernel's default time.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.ksm = {
      description = "Kernel Samepage Merging";
      wantedBy = [ "multi-user.target" ];
      unitConfig.ConditionPathExists = "/sys/kernel/mm/ksm";
      unitConfig.ConditionVirtualization = "no";
      script = ''
        echo 1 > /sys/kernel/mm/ksm/run
        ${optionalString (cfg.sleep != null) ''echo ${toString cfg.sleep} > /sys/kernel/mm/ksm/sleep_millisecs''}
      '';
    };
  };
}
