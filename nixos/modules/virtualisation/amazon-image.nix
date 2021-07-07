# Import "amazon-config.nix" and enable it.
# This supports existing "configuration.nix" files that reference this file.

{ ... }:

{
  config.ec2.enable = true;
}
