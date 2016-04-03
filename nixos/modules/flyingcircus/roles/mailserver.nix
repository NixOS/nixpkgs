{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.flyingcircus;
  fclib = import ../lib;

in
{
  options = {

    flyingcircus.roles.mailserver = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the Flying Circus mailserver *out* role.";
      };

    };
  };

  config = mkIf cfg.roles.mailserver.enable {
    services.postfix.enable = true;

    # Allow all networks on the SRV interface. We expect only trusted machines
    # can reach us there (firewall).
    services.postfix.networks =
      if cfg.enc.parameters.interfaces ? srv
      then builtins.attrNames cfg.enc.parameters.interfaces.srv.networks
      else [];
  };
}
