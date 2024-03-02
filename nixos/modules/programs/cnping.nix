{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.cnping;
in
{
  options = {
    programs.cnping = {
      enable = mkEnableOption (lib.mdDoc "a setcap wrapper for cnping");
    };
  };

  config = mkIf cfg.enable {
    security.wrappers.cnping = {
      source = "${pkgs.cnping}/bin/cnping";
      capabilities = "cap_net_raw+ep";
    };
  };
}
