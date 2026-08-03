{ config, pkgs, lib, ... }: {
  imports = [
    ../modules/desktop/budgie.nix
    ../modules/desktop/budgie-config.nix
  ];

  environment.systemPackages = with pkgs; [
    compiz-reloaded-full
    ccsm
    fusion-icon
  ];
}
