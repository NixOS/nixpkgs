{ lib, custom, ... }:

{
  imports = []
  ++ lib.optional custom ./define-enable-force.nix;
}
