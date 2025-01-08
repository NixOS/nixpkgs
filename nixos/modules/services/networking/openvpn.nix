{ config, lib, pkgs, ... }:

let

  cfg = config.services.openvpn;

  inherit (pkgs) openvpn;

  makeOpenVPNJob = cfg: name:
    let

      path = lib.makeBinPath (lib.getAttr "openvpn-${name}" config.systemd.services).path;

      upScript = ''
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
        ${lib.optionalString cfg.updateResolvConf
           "${pkgs.update-resolv-conf}/libexec/openvpn/update-resolv-conf"}
      '';

      downScript = ''
        export PATH=${path}
        ${lib.optionalString cfg.updateResolvConf
           "${pkgs.update-resolv-conf}/libexec/openvpn/update-resolv-conf"}
        ${cfg.down}
      '';

      configFile = pkgs.writeText "openvpn-config-${name}"
        ''
          errors-to-stderr
          ${lib.optionalString (cfg.up != "" || cfg.down != "" || cfg.updateResolvConf) "script-security 2"}
          ${cfg.config}
          ${lib.optionalString (cfg.up != "" || cfg.updateResolvConf)
              "up ${pkgs.writeShellScript "openvpn-${name}-up" upScript}"}
          ${lib.optionalString (cfg.down != "" || cfg.updateResolvConf)
              "down ${pkgs.writeShellScript "openvpn-${name}-down" downScript}"}
          ${lib.optionalString (cfg.authUserPass != null)
              "auth-user-pass ${pkgs.writeText "openvpn-credentials-${name}" ''
                ${cfg.authUserPass.username}
                ${cfg.authUserPass.password}
              ''}"}
        '';

    in
    {
      description = "OpenVPN instance ‘${name}’";

      wantedBy = lib.optional cfg.autoStart "multi-user.target";
      after = [ "network.target" ];

      path = [ pkgs.iptables pkgs.iproute2 pkgs.nettools ];

      serviceConfig.ExecStart = "@${openvpn}/sbin/openvpn openvpn --suppress-timestamps --config ${configFile}";
      serviceConfig.Restart = "always";
      serviceConfig.Type = "notify";
    };

  restartService = lib.optionalAttrs cfg.restartAfterSleep {
    openvpn-restart = {
      wantedBy = [ "sleep.target" ];
      path = [ pkgs.procps ];
      script = let
        unitNames = map (n: "openvpn-${n}.service") (builtins.attrNames cfg.servers);
      in "systemctl try-restart ${lib.escapeShellArgs unitNames}";
      description = "Sends a signal to OpenVPN process to trigger a restart after return from sleep";
    };
  };

in

{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "openvpn" "enable" ] "")
  ];

  ###### interface

  options = {

    services.openvpn.servers = lib.mkOption {
      default = { };

      example = lib.literalExpression ''
        {
          server = {
            config = '''
              # Simplest server configuration: https://community.openvpn.net/openvpn/wiki/StaticKeyMiniHowto
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
        `openvpn-«name».service`,
        where «name» is the corresponding
        attribute name.
      '';

      type = lib.types.attrsOf (lib.types.submodule {

        options = {

          config = lib.mkOption {
            type = lib.types.lines;
            description = ''
              Configuration of this OpenVPN instance.  See
              {manpage}`openvpn(8)`
              for details.

              To import an external config file, use the following definition:
              `config = "config /path/to/config.ovpn"`
            '';
          };

          up = lib.mkOption {
            default = "";
            type = lib.types.lines;
            description = ''
              Shell commands executed when the instance is starting.
            '';
          };

          down = lib.mkOption {
            default = "";
            type = lib.types.lines;
            description = ''
              Shell commands executed when the instance is shutting down.
            '';
          };

          autoStart = lib.mkOption {
            default = true;
            type = lib.types.bool;
            description = "Whether this OpenVPN instance should be started automatically.";
          };

          updateResolvConf = lib.mkOption {
            default = false;
            type = lib.types.bool;
            description = ''
              Use the script from the update-resolv-conf package to automatically
              update resolv.conf with the DNS information provided by openvpn. The
              script will be run after the "up" commands and before the "down" commands.
            '';
          };

          authUserPass = lib.mkOption {
            default = null;
            description = ''
              This option can be used to store the username / password credentials
              with the "auth-user-pass" authentication method.

              WARNING: Using this option will put the credentials WORLD-READABLE in the Nix store!
            '';
            type = lib.types.nullOr (lib.types.submodule {

              options = {
                username = lib.mkOption {
                  description = "The username to store inside the credentials file.";
                  type = lib.types.str;
                };

                password = lib.mkOption {
                  description = "The password to store inside the credentials file.";
                  type = lib.types.str;
                };
              };
            });
          };
        };

      });

    };

    services.openvpn.restartAfterSleep = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Whether OpenVPN client should be restarted after sleep.";
    };

  };


  ###### implementation

  config = lib.mkIf (cfg.servers != { }) {

    systemd.services = (lib.listToAttrs (lib.mapAttrsToList (name: value: lib.nameValuePair "openvpn-${name}" (makeOpenVPNJob value name)) cfg.servers))
      // restartService;

    environment.systemPackages = [ openvpn ];

    boot.kernelModules = [ "tun" ];

  };

}
