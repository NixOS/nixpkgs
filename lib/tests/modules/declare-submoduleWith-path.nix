{ lib, ... }:
{
  options.submodule = lib.mkOption {
    type = lib.types.submoduleWith {
      modules = [
        ./declare-enable.nix
      ];
    };
  };

  config.submodule = ./define-enable.nix;
}
