# TODO: use ../../common/pc/laptop

{ lib, ... }:

{
  services.xserver.synaptics.enable = lib.mkDefault true;
}
