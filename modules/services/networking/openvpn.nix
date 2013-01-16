{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.openvpn;

  inherit (pkgs) openvpn;

  makeOpenVPNJob = cfg: name:
    let

      path = (getAttr "openvpn-${name}" config.systemd.services).path;

      upScript = ''
        #! /bin/sh
        exec > /var/log/openvpn-${name}-up 2>&1
        export PATH=${path}

        # For convenience in client scripts, extract the remote domain
        # name and name server.
        for var in ''${!foreign_option_*}; do
          x=(''${!var})
          if [ "''${x[0]}" = dhcp-option ]; then
            if [ "''${x[1]}" = DOMAIN ]; then domain="''${x[2]}"
            elif [ "''${x[1]}" = DNS ]; then nameserver="''${x[2]}"
            fi
          fi
        done

        ${cfg.up}
      '';

      downScript = ''
        #! /bin/sh
        exec > /var/log/openvpn-${name}-down 2>&1
        export PATH=${path}
        ${cfg.down}
      '';

      configFile = pkgs.writeText "openvpn-config-${name}"
        ''
          ${optionalString (cfg.up != "" || cfg.down != "") "script-security 2"}
          ${cfg.config}
          ${optionalString (cfg.up != "") "up ${pkgs.writeScript "openvpn-${name}-up" upScript}"}
          ${optionalString (cfg.down != "") "down ${pkgs.writeScript "openvpn-${name}-down" downScript}"}
        '';

    in {
      description = "OpenVPN instance ‘${name}’";

      startOn = mkDefault "started network-interfaces";
      stopOn = mkDefault "stopping network-interfaces";

      path = [ pkgs.iptables pkgs.iproute pkgs.nettools ];

      exec = "${openvpn}/sbin/openvpn --config ${configFile}";
    };

in

{

  ###### interface

  options = {

    /* !!! Obsolete. */
    services.openvpn.enable = mkOption {
      default = true;
      description = "Whether to enable OpenVPN.";
    };

    services.openvpn.servers = mkOption {
      default = {};

      example = {

        server = {
          config = ''
            # Simplest server configuration: http://openvpn.net/index.php/documentation/miscellaneous/static-key-mini-howto.html.
            # server :
            dev tun
            ifconfig 10.8.0.1 10.8.0.2
            secret /root/static.key
          '';
          up = "ip route add ...";
          down = "ip route del ...";
        };

        client = {
          config = ''
            client
            remote vpn.example.org
            dev tun
            proto tcp-client
            port 8080
            ca /root/.vpn/ca.crt
            cert /root/.vpn/alice.crt
            key /root/.vpn/alice.key
          '';
          up = "echo nameserver $nameserver | ${pkgs.openresolv}/sbin/resolvconf -m 0 -a $dev";
          down = "${pkgs.openresolv}/sbin/resolvconf -d $dev";
        };

      };

      description = ''
        Each attribute of this option defines an Upstart job to run an
        OpenVPN instance.  These can be OpenVPN servers or clients.
        The name of each Upstart job is
        <literal>openvpn-</literal><replaceable>name</replaceable>,
        where <replaceable>name</replaceable> is the corresponding
        attribute name.
      '';

      type = types.attrsOf types.optionSet;

      options =  {

        config = mkOption {
          type = types.string;
            description = ''
            Configuration of this OpenVPN instance.  See
            <citerefentry><refentrytitle>openvpn</refentrytitle><manvolnum>8</manvolnum></citerefentry>
            for details.
          '';
        };

        up = mkOption {
          default = "";
          type = types.string;
          description = ''
            Shell commands executed when the instance is starting.
          '';
        };

        down = mkOption {
          default = "";
          type = types.string;
          description = ''
            Shell commands executed when the instance is shutting down.
          '';
        };

      };

    };

  };


  ###### implementation

  config = mkIf (cfg.servers != {}) {

    jobs = listToAttrs (mapAttrsFlatten (name: value: nameValuePair "openvpn-${name}" (makeOpenVPNJob value name)) cfg.servers);

    environment.systemPackages = [ openvpn ];

    boot.kernelModules = [ "tun" ];

  };

}
