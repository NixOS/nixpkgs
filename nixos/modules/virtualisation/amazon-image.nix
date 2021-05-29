# Import "amazon-config.nix" and enable it.
# This supports existing "configuration.nix" files that reference this file.

{ ... }:

{
  imports = [ ./amazon-config.nix ];
}
