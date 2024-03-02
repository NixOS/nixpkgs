{ lib, pkgs, config, ... }:
with lib;
{
  options.programs.joycond-cemuhook = {
    enable = mkEnableOption (lib.mdDoc "joycond-cemuhook, a program to enable support for cemuhook's UDP protocol for joycond devices.");
  };

  config = lib.mkIf config.programs.joycond-cemuhook.enable {
    assertions = [
      {
        assertion = config.services.joycond.enable;
        message = "joycond must be enabled through `services.joycond.enable`";
      }
    ];
    environment.systemPackages = [ pkgs.joycond-cemuhook ];
  };
}
