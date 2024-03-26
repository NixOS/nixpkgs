{ config, lib, pkgs, ... }:
let
  cfg = config.services.zram-generator;
  settingsFormat = pkgs.formats.ini { };
in
{
  meta = {
    maintainers = with lib.maintainers; [ nickcao ];
  };

  options.services.zram-generator = {
    enable = lib.mkEnableOption (lib.mdDoc "Systemd unit generator for zram devices");

    package = lib.mkPackageOption pkgs "zram-generator" { };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
      };
      default = { };
      description = lib.mdDoc ''
        Configuration for zram-generator,
        see https://github.com/systemd/zram-generator for documentation.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    system.requiredKernelConfig = with config.lib.kernelConfig; [
      (isEnabled "ZRAM")
    ];

    systemd.packages = [ cfg.package ];
    systemd.services."systemd-zram-setup@".path = [ pkgs.util-linux ]; # for mkswap

    environment.etc."systemd/zram-generator.conf".source = settingsFormat.generate "zram-generator.conf" cfg.settings;
  };
}
