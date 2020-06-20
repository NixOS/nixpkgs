# Module for rdnssd, a daemon that configures DNS servers in
# /etc/resolv/conf from IPv6 RDNSS advertisements.

{ config, lib, pkgs, ... }:

with lib;
let
  mergeHook = pkgs.writeScript "rdnssd-merge-hook" ''
    #! ${pkgs.runtimeShell} -e
    ${pkgs.openresolv}/bin/resolvconf -u
  '';
in
{

  ###### interface

  options = {

    services.rdnssd.enable = mkOption {
      type = types.bool;
      default = false;
      #default = config.networking.enableIPv6;
      description =
        ''
          Whether to enable the RDNSS daemon
          (<command>rdnssd</command>), which configures DNS servers in
          <filename>/etc/resolv.conf</filename> from RDNSS
          advertisements sent by IPv6 routers.
        '';
    };

  };


  ###### implementation

  config = mkIf config.services.rdnssd.enable {

    assertions = [{
      assertion = config.networking.resolvconf.enable;
      message = "rdnssd needs resolvconf to work (probably something sets up a static resolv.conf)";
    }];

    systemd.services.rdnssd = {
      description = "RDNSS daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        # Create the proper run directory
        mkdir -p /run/rdnssd
        touch /run/rdnssd/resolv.conf
        chown -R rdnssd /run/rdnssd

        # Link the resolvconf interfaces to rdnssd
        rm -f /run/resolvconf/interfaces/rdnssd
        ln -s /run/rdnssd/resolv.conf /run/resolvconf/interfaces/rdnssd
        ${mergeHook}
      '';

      postStop = ''
        rm -f /run/resolvconf/interfaces/rdnssd
        ${mergeHook}
      '';

      serviceConfig = {
        ExecStart = "@${pkgs.ndisc6}/bin/rdnssd rdnssd -p /run/rdnssd/rdnssd.pid -r /run/rdnssd/resolv.conf -u rdnssd -H ${mergeHook}";
        Type = "forking";
        PIDFile = "/run/rdnssd/rdnssd.pid";
      };
    };

    users.users.rdnssd = {
      description = "RDNSSD Daemon User";
      uid = config.ids.uids.rdnssd;
    };

  };

}
