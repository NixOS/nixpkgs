{pkgs, ...}:

{
  options = {
    environment.checkConfigurationOptions = pkgs.lib.mkOption {
      default = true;
      example = false;
      description = ''
        Whether to check the validity of the entire configuration.
      '';
    };
  };
}
