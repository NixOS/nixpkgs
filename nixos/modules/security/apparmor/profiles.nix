{ config, pkgs, ... }:
let
  apparmor = config.security.apparmor;
in
{
  config.security.apparmor.packages = [ pkgs.apparmor-profiles ];
}
