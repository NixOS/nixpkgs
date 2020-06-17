{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.liboping;
in {
  options.programs.liboping = {
    enable = mkEnableOption "liboping";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ liboping ];
    security.wrappers = mkMerge (map (
      exec: {
        "${exec}" = {
          source = "${pkgs.liboping}/bin/${exec}";
          capabilities = "cap_net_raw+p";
        };
      }
    ) [ "oping" "noping" ]);
  };
}
