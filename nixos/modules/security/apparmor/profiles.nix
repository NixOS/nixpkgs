{ config, pkgs, ... }:

{
  config.security.apparmor.packages = [ pkgs.apparmor-profiles ];
}
