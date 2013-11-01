{ pkgs, ... }:

with pkgs.lib;

{
  options = {
    environment.checkConfigurationOptions = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to check the validity of the entire configuration.
      '';
    };
  };
}
