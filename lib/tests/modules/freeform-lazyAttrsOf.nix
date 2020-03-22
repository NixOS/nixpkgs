{ lib, ... }: {
  config._module.freeformType = with lib.types; lazyAttrsOf (either str (lazyAttrsOf str));
}
