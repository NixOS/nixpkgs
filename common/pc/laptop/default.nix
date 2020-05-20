{ config, lib, ... }:

{
  imports = [ ../. ];

  services.tlp.enable = lib.mkDefault true;
}
