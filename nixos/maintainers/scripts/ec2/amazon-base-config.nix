{ ... }:
{
  imports = [ <nixpkgs/nixos/modules/virtualisation/amazon-config.nix> ];
  services.journald.rateLimitBurst = 0;
}
