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
    zero_pages = mkOption {
      default = null;
      type = types.nullOr (types.ints.between 0 1);
      description = ''
        ksm will merge kernel zero pages with ksm zero pages if this is set to <literal>1</literal>.
	Only ksm zero pages are merged by default. Kernel zero pages are merged if this is enabled.
	The default is <literal>0</literal>. This option is defined <literal>null</literal>.
	Care should be taken enabling this setting as it can degrade performance in many scenarios.
	Performance can be increased on architectures with colored zero pages.
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
        ${optionalString (cfg.zero_pages != null)
	''echo ${toString cfg.zero_pages} > /sys/kernel/mm/ksm/use_zero_pages''}
      '';
    };
  };
}
