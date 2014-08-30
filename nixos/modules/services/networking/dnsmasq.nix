{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.dnsmasq;
  dnsmasq = pkgs.dnsmasq;

  dnsmasqConf = pkgs.writeText "dnsmasq.conf" ''
    ${optionalString cfg.resolveLocalQueries ''
      conf-file=/etc/dnsmasq-conf.conf
      resolv-file=/etc/dnsmasq-resolv.conf
    ''}
      ${cfg.extraConfig}
  '';

in

{

  ###### interface

  options = {

    services.dnsmasq = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to run dnsmasq.
        '';
      };

      resolveLocalQueries = mkOption {
        default = true;
        description = ''
          Whether dnsmasq should resolve local queries (i.e. add 127.0.0.1 to
          /etc/resolv.conf)
        '';
      };

      servers = mkOption {
        default = [];
        example = [ "8.8.8.8" "8.8.4.4" ];
        description = ''
          The parameter to dnsmasq -S.
        '';
      };



      extraConfig = mkOption {
        type = types.string;
        default = "";
        description = ''
          Extra configuration directives that should be added to
          <literal>dnsmasq.conf</literal>
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.dnsmasq.enable {

    environment.systemPackages = [ dnsmasq ]
      ++ (if cfg.resolveLocalQueries then [ pkgs.openresolv ] else []);

    services.dbus.packages = [ dnsmasq ];

    users.extraUsers = singleton
      { name = "dnsmasq";
        uid = config.ids.uids.dnsmasq;
        description = "Dnsmasq daemon user";
        home = "/var/empty";
      };

    systemd.services.dnsmasq = {
        description = "dnsmasq daemon";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "dbus";
          BusName = "uk.org.thekelleys.dnsmasq";
          ExecStartPre = "${dnsmasq}/bin/dnsmasq --test";
          ExecStart = "${dnsmasq}/bin/dnsmasq -k --enable-dbus --user=dnsmasq -C ${dnsmasqConf}";
          ExecReload = "${dnsmasq}/bin/kill -HUP $MAINPID";
        };
    };

  };

}
