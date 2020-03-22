{ lib, ... }: {
  config._module.freeformType = with lib.types; attrsOf (either str (attrsOf str));
}
