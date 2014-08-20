{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.security.firejail;
in
{
  options = {
    security.firejail = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable firejail support, a lightweight solution for running
          untrusted applications in a restricted environment.

          This option will install the firejail program along with a
          setuid wrapper which permits use by non-privileged users.
        '';
      };
    };
  };

  config = {
     environment.systemPackages = [ pkgs.firejail ];
     security.setuidPrograms    = [ "firejail" ];
  };
}
