{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.programs.mdevctl;
in {
  options.programs.mdevctl = {
    enable = mkEnableOption (lib.mdDoc "Mediated Device Management");
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ mdevctl ];

    environment.etc."mdevctl.d/scripts.d/notifiers/.keep".text = "";
    environment.etc."mdevctl.d/scripts.d/callouts/.keep".text = "";

  };
}
