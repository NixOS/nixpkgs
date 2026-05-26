{ lib, ... }:
{
  options.submodule = lib.mkOption {
    type = lib.types.submoduleWith {
      modules = [
        ./declare-enable.nix
      ];
    };
    default = { };
  };

  config.submodule = ./define-enable.nix;
}
