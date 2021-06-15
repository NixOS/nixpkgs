{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.auto-cpufreq;
in {
  options = {
    services.auto-cpufreq = {
      enable = mkEnableOption "auto-cpufreq daemon";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.auto-cpufreq ];

    systemd.packages = [ pkgs.auto-cpufreq ];
    systemd.services.auto-cpufreq.path = with pkgs; [ bash coreutils ];
  };
}
