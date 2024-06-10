{ lib, ... }: {
  freeformType = with lib.types; lazyAttrsOf (either str (lazyAttrsOf str));
}
