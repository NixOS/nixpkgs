{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.clipcat;
in {

  options.services.clipcat= {
    enable = mkEnableOption "Clipcat clipboard daemon";

    package = mkOption {
      type = types.package;
      default = pkgs.clipcat;
      defaultText = literalExpression "pkgs.clipcat";
      description = lib.mdDoc "clipcat derivation to use.";
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.clipcat = {
      enable      = true;
      description = "clipcat daemon";
      wantedBy = [ "graphical-session.target" ];
      after    = [ "graphical-session.target" ];
      serviceConfig.ExecStart = "${cfg.package}/bin/clipcatd --no-daemon";
    };

    environment.systemPackages = [ cfg.package ];
  };
}
