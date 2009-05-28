# From an end-user configuration file (`configuration'), build a NixOS
# configuration object (`config') from which we can retrieve option
# values.

{configuration, pkgs}:

rec {
  configComponents = [
    configuration
    {
      require = import ../modules/module-list.nix;
      environment.checkConfigurationOptions = pkgs.lib.mkOption {
        default = true;
        example = false;
        description = ''
          Whether to check the validity of the entire configuration.
        '';
      };
    }
  ];

  config =
    pkgs.lib.fixOptionSets
      pkgs.lib.mergeOptionSets
      pkgs configComponents;

  optionDeclarations =
    pkgs.lib.fixOptionSetsFun
      pkgs.lib.filterOptionSets
      pkgs configComponents
      config;
}
