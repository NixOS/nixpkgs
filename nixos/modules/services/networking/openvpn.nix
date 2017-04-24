{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.openvpn;

  inherit (pkgs) openvpn;

  makeOpenVPNJob = cfg: name:
    let

      path = (getAttr "openvpn-${name}" config.systemd.services).path;

      upScript = ''
        #! /bin/sh
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

        ${optionalString cfg.updateResolvConf
           "${pkgs.update-resolv-conf}/libexec/openvpn/update-resolv-conf"}

        ${optionalString (cfg.up != "") "source ${userSuppliedUpScript}"}
      '';

      downScript = ''
        #! /bin/sh
        export PATH=${path}
        ${optionalString cfg.updateResolvConf
           "${pkgs.update-resolv-conf}/libexec/openvpn/update-resolv-conf"}

        ${optionalString (cfg.down != "") "source ${userSuppliedDownScript}"}
      '';

      userSuppliedUpScript = pkgs.writeScript "openvpn-${name}-userSuppliedUpScript" ''
        ${cfg.up}
      '';

      userSuppliedDownScript = pkgs.writeScript "openvpn-${name}-userSuppliedDownScript" ''
        ${cfg.down}
      '';

      configFile = pkgs.writeText "openvpn-config-${name}"
        ''
          errors-to-stderr
          ${optionalString (cfg.up != "" || cfg.down != "" || cfg.updateResolvConf) "script-security 2"}
          ${cfg.config}
          ${optionalString (cfg.up != "" || cfg.updateResolvConf)
              "up ${pkgs.writeScript "openvpn-${name}-up" upScript}"}
          ${optionalString (cfg.down != "" || cfg.updateResolvConf)
              "down ${pkgs.writeScript "openvpn-${name}-down" downScript}"}
        '';

    in {
      description = "OpenVPN instance ‘${name}’";

      wantedBy = optional cfg.autoStart "multi-user.target";
      after = [ "network.target" ];

      path = [ pkgs.iptables pkgs.iproute pkgs.nettools ];

      serviceConfig.ExecStart = "@${openvpn}/sbin/openvpn openvpn --config ${configFile}";
      serviceConfig.Restart = "always";
      serviceConfig.Type = "notify";
    };

in

{

  ###### interface

  options = {

    services.openvpn.servers = mkOption {
      default = {};

      example = literalExample ''
        {
          server = {
            config = '''
              # Simplest server configuration: http://openvpn.net/index.php/documentation/miscellaneous/static-key-mini-howto.html.
              # server :
              dev tun
              ifconfig 10.8.0.1 10.8.0.2
              secret /root/static.key
            ''';
            up = "ip route add ...";
            down = "ip route del ...";
          };

          client = {
            config = '''
              client
              remote vpn.example.org
              dev tun
              proto tcp-client
              port 8080
              ca /root/.vpn/ca.crt
              cert /root/.vpn/alice.crt
              key /root/.vpn/alice.key
            ''';
            up = "echo nameserver $nameserver | ''${pkgs.openresolv}/sbin/resolvconf -m 0 -a $dev";
            down = "''${pkgs.openresolv}/sbin/resolvconf -d $dev";
          };
        }
      '';

      description = ''
        Each attribute of this option defines a systemd service that
        runs an OpenVPN instance.  These can be OpenVPN servers or
        clients.  The name of each systemd service is
        <literal>openvpn-<replaceable>name</replaceable>.service</literal>,
        where <replaceable>name</replaceable> is the corresponding
        attribute name.
      '';

      type = with types; attrsOf (submodule {

        options = {

          config = mkOption {
            type = types.lines;
            description = ''
              Configuration of this OpenVPN instance.  See
              <citerefentry><refentrytitle>openvpn</refentrytitle><manvolnum>8</manvolnum></citerefentry>
              for details.
            '';
          };

          up = mkOption {
            default = "";
            type = types.lines;
            description = ''
              Shell script sourced by NixOS generated script when the instance is starting.
            '';
          };

          down = mkOption {
            default = "";
            type = types.lines;
            description = ''
              Shell script sourced by NixOS generated script when the instance is shutting down.
            '';
          };

          autoStart = mkOption {
            default = true;
            type = types.bool;
            description = "Whether this OpenVPN instance should be started automatically.";
          };

          updateResolvConf = mkOption {
            default = false;
            type = types.bool;
            description = ''
              Use the script from the update-resolv-conf package to automatically
              update resolv.conf with the DNS information provided by openvpn. The
              script will be run after the "up" commands and before the "down" commands.
            '';
          };

        };

      });

    };

  };


  ###### implementation

  config = mkIf (cfg.servers != {}) {

    systemd.services = listToAttrs (mapAttrsFlatten (name: value: nameValuePair "openvpn-${name}" (makeOpenVPNJob value name)) cfg.servers);

    environment.systemPackages = [ openvpn ];

    boot.kernelModules = [ "tun" ];

  };

}
