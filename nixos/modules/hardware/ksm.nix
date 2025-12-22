{ config, lib, ... }:
let
  cfg = config.hardware.ksm;

in
{
  imports = [
    (lib.mkRenamedOptionModule [ "hardware" "enableKSM" ] [ "hardware" "ksm" "enable" ])
  ];

  options.hardware.ksm = {
    enable = lib.mkEnableOption "Linux kernel Same-Page Merging";
    sleep = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = ''
        How many milliseconds ksmd should sleep between scans.
        Setting it to `null` uses the kernel's default time.
      '';
    };
    scan = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = ''
        How many pages ksmd should scan.
        Setting it to `null` uses the kernel's default value.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.enable-ksm = {
      description = "Enable Kernel Same-Page Merging";
      wantedBy = [ "multi-user.target" ];
      script = ''
        echo 1 > /sys/kernel/mm/ksm/run
      ''
      + lib.optionalString (cfg.sleep != null) ''
        echo ${toString cfg.sleep} > /sys/kernel/mm/ksm/sleep_millisecs
      ''
      + lib.optionalString (cfg.scan != null) ''
        echo ${toString cfg.scan} > /sys/kernel/mm/ksm/pages_to_scan
      '';
    };
  };
}
