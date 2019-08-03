{ config, lib, pkgs, ... }:
let
  cfg = config.security.apparmor;
in
with lib;
{

  options.security.apparmor.confineSUIDApplications = mkOption {
    default = true;
    description = ''
      Install AppArmor profiles for commonly-used SUID application
      to mitigate potential privilege escalation attacks due to bugs
      in such applications.

      Currently available profiles: ping
    '';
  };

  config = mkIf (cfg.confineSUIDApplications) {
    security.apparmor.profiles = [ (pkgs.writeText "ping" ''
      #include <tunables/global>
      /run/wrappers/bin/ping {
        #include <abstractions/base>
        #include <abstractions/consoles>
        #include <abstractions/nameservice>

        capability net_raw,
        capability setuid,
        network inet raw,

        ${pkgs.stdenv.cc.libc.out}/lib/*.so mr,
        ${pkgs.libcap.lib}/lib/libcap.so* mr,
        ${pkgs.attr.out}/lib/libattr.so* mr,

        ${pkgs.iputils}/bin/ping mixr,

        #/etc/modules.conf r,

        ## Site-specific additions and overrides. See local/README for details.
        ##include <local/bin.ping>
      }
    '') ];
  };

}
