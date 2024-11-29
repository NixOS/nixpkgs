{ config, lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.bare-submodule = mkOption {
    type = types.submoduleWith {
      modules = [ ];
      shorthandOnlyDefinesConfig = config.shorthandOnlyDefinesConfig;
    };
    default = {};
  };

  # config-dependent options: won't recommend, but useful for making this test parameterized
  options.shorthandOnlyDefinesConfig = mkOption {
    default = false;
  };
}
