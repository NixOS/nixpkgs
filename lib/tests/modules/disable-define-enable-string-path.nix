{ lib, ... }:

{
  disabledModules = [ (toString ./define-enable.nix) ];
}
