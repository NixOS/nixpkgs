{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.hardware.hip;

in

{
  options.hardware.hip = {
    enable = lib.mkEnableOption (lib.mdDoc "Heterogeneous-Compute Interface for Portability (HIP)");
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.hip}"
    ];
  };
}
