{ config, lib, pkgs, ... }:
let
  cfg = config.services.bpftune;
in
{
  meta = {
    maintainers = with lib.maintainers; [ nickcao ];
  };

  options = {
    services.bpftune = {
      enable = lib.mkEnableOption (lib.mdDoc "bpftune BPF driven auto-tuning");

      package = lib.mkPackageOptionMD pkgs "bpftune" { };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.packages = [ cfg.package ];
    systemd.services.bpftune.wantedBy = [ "multi-user.target" ];
  };
}
