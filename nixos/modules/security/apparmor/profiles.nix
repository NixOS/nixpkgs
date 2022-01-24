{ config, lib, pkgs, ... }:
let apparmor = config.security.apparmor; in
{
config.security.apparmor.packages = [ pkgs.apparmor-profiles ];
config.security.apparmor.policies."bin.ping".profile = lib.mkIf apparmor.policies."bin.ping".enable ''
  include "${pkgs.iputils.apparmor}/bin.ping"
  include "${pkgs.inetutils.apparmor}/bin.ping"
  # Note that including those two profiles in the same profile
  # would not work if the second one were to re-include <tunables/global>.
'';
}
