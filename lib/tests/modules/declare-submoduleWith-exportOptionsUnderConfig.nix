{ lib, ... }:

{
  options.submodule = lib.mkOption {
    type = lib.types.submoduleWith {
      modules = [ ];
      exportOptionsUnderConfig = true;
    };
  };
}
