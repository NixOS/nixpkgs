{ config, pkgs, ...}:
{
  imports = [ ./amazon-base-config.nix ];
  ec2.hvm = true;
}
