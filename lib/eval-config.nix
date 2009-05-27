# From an end-user configuration file (`configuration'), build a NixOS
# configuration object (`config') from which we can retrieve option
# values.

{configuration, pkgs}:

rec {
  configComponents = [
    configuration
    (import ../system/options.nix)
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
