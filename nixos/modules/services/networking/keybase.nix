{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.keybase;

in {

  ###### interface

  options = {

    services.keybase = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to start the Keybase service.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.keybase;
        defaultText = "pkgs.keybase";
        example = literalExample "pkgs.keybase";
        description = "Keybase derivation to use.";
      };

    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    systemd.user.services.keybase = {
      description = "Keybase service";
      serviceConfig = {
        ExecStart = ''
	  ${cfg.package}/bin/keybase service --auto-forked
	'';
        Restart = "on-failure";
      };
    };

    environment.systemPackages = [ cfg.package ];
  };
}
