{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.greenclip;
in {

  options.services.greenclip = {
    enable = mkEnableOption "Whether to enable the greenclip daemon that will listen to selections";

    package = mkOption {
      type = types.package;
      default = pkgs.haskellPackages.greenclip;
      defaultText = "pkgs.haskellPackages.greenclip";
      description = "greenclip derivation to use.";
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.greenclip = {
      enable      = true;
      description = "greenclip daemon";
      wantedBy = [ "graphical-session.target" ];
      after    = [ "graphical-session.target" ];
      serviceConfig.ExecStart = "${cfg.package}/bin/greenclip daemon";
    };

    environment.systemPackages = [ cfg.package ];
  };
}
