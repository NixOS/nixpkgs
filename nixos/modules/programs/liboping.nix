{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.liboping;
in {
  options.programs.liboping = {
    enable = mkEnableOption (lib.mdDoc "liboping");
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ liboping ];
    security.wrappers = mkMerge (map (
      exec: {
        "${exec}" = {
          owner = "root";
          group = "root";
          capabilities = "cap_net_raw+p";
          source = "${pkgs.liboping}/bin/${exec}";
        };
      }
    ) [ "oping" "noping" ]);
  };
}
