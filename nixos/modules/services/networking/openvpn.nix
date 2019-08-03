{ config, lib, pkgs, ... }:

let
  cfg = config.services.openvpn;

  enable = cfg.servers != { };

  inherit (lib)
    mkIf mkOption mkRemovedOptionModule literalExample types
    getAttr makeBinPath
    concatStringsSep
    optional optionalAttrs optionalString
    listToAttrs mapAttrsFlatten nameValuePair;

  inherit (pkgs) writeShellScript writeText;

  makeOpenVPNJob = cfg: name:
    let
      path = makeBinPath (getAttr "openvpn-${name}" config.systemd.services).path;

      hasUpScript =
        cfg.up != "" || cfg.updateResolvConf || updateResolved;

      hasDownScript =
        cfg.down != "" || cfg.updateResolvConf || updateResolved;

      updateResolvConfBin = "${pkgs.update-resolv-conf}/libexec/openvpn/update-resolv-conf";

      updateResolved = config.services.resolved.enable;

      updateResolvedBin = "${pkgs.update-systemd-resolved}/libexec/openvpn/update-systemd-resolved";

      upScript = ''
        export PATH=${path}

        # For convenience in client scripts, extract the remote domain
        # name and name server.
        for var in ''${!foreign_option_*}; do
          x=(''${!var})
          if [ "''${x[0]}" = dhcp-option ]; then
            if [ "''${x[1]}" = DOMAIN ]; then
              domain="''${x[2]}"
            elif [ "''${x[1]}" = DNS ]; then
              nameserver="''${x[2]}"
            fi
          fi
        done

        ${cfg.up}

        ${optionalString cfg.updateResolvConf updateResolvConfBin}
        ${optionalString updateResolved updateResolvedBin}
      '';

      downScript = ''
        export PATH=${path}

        ${optionalString cfg.updateResolvConf updateResolvConfBin}
        ${optionalString updateResolved updateResolvedBin}

        ${cfg.down}
      '';

      configFile = writeText "openvpn-config-${name}" ''
        errors-to-stderr
        ${optionalString (hasUpScript || hasDownScript) "script-security 2"}
        ${cfg.config}
        ${optionalString hasUpScript
          "up ${writeShellScript "openvpn-${name}-up" upScript}"}
        ${optionalString hasDownScript
          "down ${writeShellScript "openvpn-${name}-down" downScript}"}
        ${optionalString (cfg.authUserPass != null)
          "auth-user-pass ${writeText "openvpn-credentials-${name}" ''
            ${cfg.authUserPass.username}
            ${cfg.authUserPass.password}
          ''}"}
      '';

    in
    {
      description = "OpenVPN instance ‘${name}’";

      wantedBy = optional cfg.autoStart "openvpn.target";
      after = [ "network.target" ];

      path = with pkgs; [ iptables iproute2 nettools ];

      serviceConfig = {
        ExecStart = concatStringsSep " " [
          "@${pkgs.openvpn}/sbin/openvpn"
          "openvpn"
          "--suppress-timestamps"
          "--config ${configFile}"
        ];
        Restart = "always";
        Type = "notify";
        RuntimeDirectory = "openvpn";
        StateDirectory = "openvpn";
        Slice = "openvpn.slice";
      };
    };

in

{
  imports = [
    (mkRemovedOptionModule [ "services" "openvpn" "enable" ] "")
  ];

  ###### interface

  options.services.openvpn = {

    enableForwarding = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Set up IP forwarding on the host to allow reaching the network behind the host.
      '';
    };

    servers = mkOption {
      default = { };

      example = literalExample ''
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
              </para><para>
              To import an external config file, use the following definition:
              <literal>config = "config /path/to/config.ovpn"</literal>
            '';
          };

          settings = mkOption {
            type = types.attrs;
            default = { };
            description = ''
              Configuration of this OpenVPN instance.  See
              <citerefentry><refentrytitle>openvpn</refentrytitle><manvolnum>8</manvolnum></citerefentry>
              for details.
              </para><para>
              To import an external config file, use the following definition:
              <literal>config = "config /path/to/config.ovpn"</literal>
              </para><para>
              An attrset with settings instead of plain text. Mutually exclusive with config.
            '';
          };

          up = mkOption {
            default = "";
            type = types.lines;
            description = ''
              Shell commands executed when the instance is starting.
            '';
          };

          down = mkOption {
            default = "";
            type = types.lines;
            description = ''
              Shell commands executed when the instance is shutting down.
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

          authUserPass = mkOption {
            default = null;
            description = ''
              This option can be used to store the username / password credentials
              with the "auth-user-pass" authentication method.

              WARNING: Using this option will put the credentials WORLD-READABLE in the Nix store!
            '';
            type = types.nullOr (types.submodule {
              options = {
                username = mkOption {
                  description = "The username to store inside the credentials file.";
                  type = types.str;
                };

                password = mkOption {
                  description = "The password to store inside the credentials file.";
                  type = types.str;
                };
              };
            });
          };
        };
      });
    };
  };

  ###### implementation

  config = mkIf enable {
    systemd.services = listToAttrs (mapAttrsFlatten (name: value: nameValuePair "openvpn-${name}" (makeOpenVPNJob value name)) cfg.servers);

    systemd.targets.openvpn = {
      description = "OpenVPN instances";
      wantedBy = [ "multi-user.target" ];
    };

    environment.systemPackages = with pkgs; [ openvpn ];

    boot.kernelModules = [ "tun" ];

    boot.kernel.sysctl = mkIf cfg.enableForwarding ({
      "net.ipv4.ip_forward" = true;
    } // (optionalAttrs config.networking.enableIPv6 {
      "net.ipv6.conf.all.forwarding" = true;
    }));

    users = {
      users.openvpn = {
        description = "OpenVPN";
        isNormalUser = false;
        isSystemUser = true;
        group = "openvpn";
      };

      groups.openvpn = { };
    };
  };
}
