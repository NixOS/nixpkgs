{ config, lib, ... }:

with lib;

let
  cfg = config.hardware.ksm;

in {
  imports = [
    (mkRenamedOptionModule [ "hardware" "enableKSM" ] [ "hardware" "ksm" "enable" ])
  ];

  options.hardware.ksm = {
    enable = mkEnableOption "Kernel Same-Page Merging";
    sleep = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = lib.mdDoc ''
        How many milliseconds ksmd should sleep between scans.
        Setting it to `null` uses the kernel's default time.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.enable-ksm = {
      description = "Enable Kernel Same-Page Merging";
      wantedBy = [ "multi-user.target" ];
      script =
        ''
          echo 1 > /sys/kernel/mm/ksm/run
        '' + optionalString (cfg.sleep != null)
        ''
          echo ${toString cfg.sleep} > /sys/kernel/mm/ksm/sleep_millisecs
        '';
    };
  };
}
