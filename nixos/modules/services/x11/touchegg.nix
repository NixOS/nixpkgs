{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.touchegg;

in {
  meta = {
    maintainers = teams.pantheon.members;
  };

  ###### interface
  options.services.touchegg = {
    enable = mkEnableOption (lib.mdDoc "touchegg, a multi-touch gesture recognizer");

    package = mkOption {
      type = types.package;
      default = pkgs.touchegg;
      defaultText = literalExpression "pkgs.touchegg";
      description = lib.mdDoc "touchegg derivation to use.";
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    systemd.services.touchegg = {
      description = "Touchegg Daemon";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/touchegg --daemon";
        Restart = "on-failure";
      };
      wantedBy = [ "multi-user.target" ];
    };

    environment.systemPackages = [ cfg.package ];
  };
}
