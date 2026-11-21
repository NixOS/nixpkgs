{ config, pkgs, ... }:
let

in
{
  config.security.apparmor.packages = [ pkgs.apparmor-profiles ];
}
