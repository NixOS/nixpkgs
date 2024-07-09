{ lib, ... }: {
  freeformType = with lib.types; attrsOf (either str (attrsOf str));
}
