{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.auto-cpufreq;
in {
  options = {
    services.auto-cpufreq = {
      enable = mkEnableOption (lib.mdDoc "auto-cpufreq daemon");
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.auto-cpufreq ];

    systemd = {
      packages = [ pkgs.auto-cpufreq ];
      services.auto-cpufreq = {
        # Workaround for https://github.com/NixOS/nixpkgs/issues/81138
        wantedBy = [ "multi-user.target" ];
        path = with pkgs; [ bash coreutils ];
      };
    };
  };
}
