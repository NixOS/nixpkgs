{ config, pkgs, lib, ... }:

let
  cfg = config.programs.iotop;
in {
  options.programs.iotop = {
    enable = lib.mkEnableOption "iotop + setcap wrapper";
    useDelayacct = lib.mkEnableOption "Enable the task_delayacct kernel task delay accounting in order to show all statistics.";
  };
  config = lib.mkIf cfg.enable {
    security.wrappers.iotop = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_admin+p";
      source = "${pkgs.iotop}/bin/iotop";
    };
    boot.kernel.sysctl = lib.mkIf cfg.useDelayacct { "kernel.task_delayacct" = 1; };
  };
}
