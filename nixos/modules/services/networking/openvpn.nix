{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  cfg = config.services.openvpn;
  enabledServers = filterAttrs (name: srv: srv.enable) cfg.servers;

  inherit (pkgs) openvpn;

  PATH = name: makeBinPath config.systemd.services."openvpn-${name}".path;

  makeOpenVPNJob =
    cfg: name:
    let

      configFile = pkgs.writeText "openvpn-config-${name}" (
        generators.toKeyValue {
          mkKeyValue =
            key: value:
            if hasAttr key scripts then
              "${key} " + pkgs.writeShellScript "openvpn-${name}-${key}" (scripts.${key} value)
            else if builtins.isBool value then
              optionalString value key
            else if builtins.isPath value then
              "${key} ${value}"
            else if builtins.isList value then
              concatMapStringsSep "\n" (v: "${key} ${generators.mkValueStringDefault { } v}") value
            else
              "${key} ${generators.mkValueStringDefault { } value}";
        } cfg.settings
      );

      scripts = {
        up =
          script:
          let
            init = ''
              export PATH=${PATH name}

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

              ${optionalString cfg.updateResolvConf "${pkgs.update-resolv-conf}/libexec/openvpn/update-resolv-conf"}
            '';
            # Add DNS settings given in foreign DHCP options to the resolv.conf of the netns.
            # Note that JoinsNamespaceOf="netns-${cfg.netns}.service" will not
            # BindReadOnlyPaths=["/etc/netns/${cfg.netns}/resolv.conf:/etc/resolv.conf"];
            # this will have to be added in each service joining the namespace.
            setNetNSResolvConf = ''
              mkdir -p /etc/netns/${cfg.netns}
              # This file is normally created by netns-${cfg.netns}.service,
              # care must be taken to not delete it but to truncate it
              # in order to propagate the changes to bind-mounted versions.
              : > /etc/netns/${cfg.netns}/resolv.conf
              chmod 644 /etc/netns/${cfg.netns}/resolv.conf
              foreign_opt_domains=
              process_foreign_option () {
                case "$1:$2" in
                  dhcp-option:DNS) echo "nameserver $3" >>/etc/netns/'${cfg.netns}'/resolv.conf ;;
                  dhcp-option:DOMAIN) foreign_opt_domains="$foreign_opt_domains $3" ;;
                esac
              }
              i=1
              while
                eval opt=\"\''${foreign_option_$i-}\"
                [ -n "$opt" ]
              do
                process_foreign_option $opt
                i=$(( i + 1 ))
              done
              for d in $foreign_opt_domains; do
                printf '%s\n' "domain $1" "search $*" \
                  >>/etc/netns/'${cfg.netns}'/resolv.conf
              done
            '';
          in
          if cfg.netns == null then
            ''
              ${init}
              ${script}
            ''
          else
            ''
              export PATH=${PATH name}
              set -eux
              ${setNetNSResolvConf}
              ip link set dev '${cfg.settings.dev}' up netns '${cfg.netns}' mtu "$tun_mtu"
              ip netns exec '${cfg.netns}' ${pkgs.writeShellScript "openvpn-${name}-up-netns.sh" ''
                ${init}
                set -eux
                export PATH=${PATH name}

                ip link set dev lo up

                netmask4="''${ifconfig_netmask:-30}"
                netbits6="''${ifconfig_ipv6_netbits:-112}"
                if [ -n "''${ifconfig_local-}" ]; then
                  if [ -n "''${ifconfig_remote-}" ]; then
                    ip -4 addr replace \
                      local "$ifconfig_local" \
                      peer "$ifconfig_remote/$netmask4" \
                      ''${ifconfig_broadcast:+broadcast "$ifconfig_broadcast"} \
                      dev '${cfg.settings.dev}'
                  else
                    ip -4 addr replace \
                      local "$ifconfig_local/$netmask4" \
                      ''${ifconfig_broadcast:+broadcast "$ifconfig_broadcast"} \
                      dev '${cfg.settings.dev}'
                  fi
                fi
                if [ -n "''${ifconfig_ipv6_local-}" ]; then
                  if [ -n "''${ifconfig_ipv6_remote-}" ]; then
                    ip -6 addr replace \
                      local "$ifconfig_ipv6_local" \
                      peer "$ifconfig_ipv6_remote/$netbits6" \
                      dev '${cfg.settings.dev}'
                  else
                    ip -6 addr replace \
                      local "$ifconfig_ipv6_local/$netbits6" \
                      dev '${cfg.settings.dev}'
                  fi
                fi
                set +eux
                ${script}
              ''}
            '';
        route-up =
          script:
          if cfg.netns == null then
            script
          else
            ''
              export PATH=${PATH name}
              set -eux
              ip netns exec '${cfg.netns}' ${pkgs.writeShellScript "openvpn-${name}-route-up-netns" ''
                export PATH=${PATH name}
                set -eux
                i=1
                while
                  eval net=\"\''${route_network_$i-}\"
                  eval mask=\"\''${route_netmask_$i-}\"
                  eval gw=\"\''${route_gateway_$i-}\"
                  eval mtr=\"\''${route_metric_$i-}\"
                  [ -n "$net" ]
                do
                  ip -4 route replace "$net/$mask" via "$gw" ''${mtr:+metric "$mtr"}
                  i=$(( i + 1 ))
                done

                if [ -n "''${route_vpn_gateway-}" ]; then
                  ip -4 route replace default via "$route_vpn_gateway"
                fi

                i=1
                while
                  # There doesn't seem to be $route_ipv6_metric_<n>
                  # according to the manpage.
                  eval net=\"\''${route_ipv6_network_$i-}\"
                  eval gw=\"\''${route_ipv6_gateway_$i-}\"
                  [ -n "$net" ]
                do
                  ip -6 route replace  "$net"  via "$gw"  metric 100
                  i=$(( i + 1 ))
                done

                # There's no $route_vpn_gateway for IPv6. It's not
                # documented if OpenVPN includes default route in
                # $route_ipv6_*. Set default route to remote VPN
                # endpoint address if there is one. Use higher metric
                # than $route_ipv6_* routes to give preference to a
                # possible default route in them.
                if [ -n "''${ifconfig_ipv6_remote-}" ]; then
                  ip -6 route replace default \
                    via "$ifconfig_ipv6_remote" metric 200
                fi
                ${script}
              ''}
            '';
        down =
          script:
          let
            init = ''
              export PATH=${PATH name}
              ${optionalString cfg.updateResolvConf "${pkgs.update-resolv-conf}/libexec/openvpn/update-resolv-conf"}
            '';
          in
          if cfg.netns == null then
            ''
              ${init}
              ${script}
            ''
          else
            ''
              export PATH=${PATH name}
              ip netns exec '${cfg.netns}' ${pkgs.writeShellScript "openvpn-${name}-down-netns.sh" ''
                ${init}
                ${script}
              ''}
              rm -f /etc/netns/'${cfg.netns}'/resolv.conf
            '';
      };

    in
    {
      description = "OpenVPN instance ‘${name}’";

      wantedBy = optional cfg.autoStart "multi-user.target";
      after = [ "network.target" ];
      bindsTo = optional (cfg.netns != null) "netns-${cfg.netns}.service";
      requires = optional (cfg.netns != null) "netns-${cfg.netns}.service";

      path = [
        pkgs.iptables
        pkgs.iproute2
        pkgs.nettools
      ];

      serviceConfig.ExecStart = "@${openvpn}/sbin/openvpn openvpn --suppress-timestamps --config ${configFile}";
      serviceConfig.Restart = "always";
      serviceConfig.RestartSec = "5s";
      serviceConfig.Type = "notify";
    };

  restartService = optionalAttrs cfg.restartAfterSleep {
    openvpn-restart = {
      wantedBy = [ "sleep.target" ];
      path = [ pkgs.procps ];
      script =
        let
          unitNames = map (n: "openvpn-${n}.service") (builtins.attrNames cfg.servers);
        in
        "systemctl try-restart ${lib.escapeShellArgs unitNames}";
      description = "Sends a signal to OpenVPN process to trigger a restart after return from sleep";
    };
  };

in

{
  imports = [
    (mkRemovedOptionModule [ "services" "openvpn" "enable" ] "")
  ];

  ###### interface

  options = {

    services.openvpn.servers = mkOption {
      default = { };

      example = literalExpression ''
        {
          server = {
            settings = {
              # Simplest server configuration: https://community.openvpn.net/openvpn/wiki/StaticKeyMiniHowto
              # server :
              dev = "tun";
              ifconfig = "10.8.0.1 10.8.0.2";
              secret = "/root/static.key";
              up = "ip route add ...";
              down = "ip route del ...";
            };
          };

          client = {
            settings = {
              client = true;
              remote = "vpn.example.org";
              dev = "tun";
              proto = "tcp-client";
              port = 8080;
              ca = "/root/.vpn/ca.crt";
              cert = "/root/.vpn/alice.crt";
              key = "/root/.vpn/alice.key";
              up = "echo nameserver $nameserver | ''${pkgs.openresolv}/sbin/resolvconf -m 0 -a $dev";
              down = "''${pkgs.openresolv}/sbin/resolvconf -d $dev";
            };
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

      type =
        with types;
        attrsOf (
          submodule (
            {
              name,
              config,
              options,
              ...
            }:
            {

              options = rec {
                enable = mkEnableOption "OpenVPN server" // {
                  default = true;
                };

                settings = mkOption {
                  description = ''
                    Configuration of this OpenVPN instance.  See
                    {manpage}`openvpn(8)`
                    for details.

                    To import an external config file, use the following definition:
                    config = /path/to/config.ovpn;
                  '';
                  default = { };
                  type = types.submodule {
                    freeformType =
                      with types;
                      attrsOf (
                        nullOr (oneOf [
                          bool
                          int
                          str
                          path
                          (listOf (oneOf [
                            bool
                            int
                            str
                            path
                          ]))
                        ])
                      );
                    options.dev = mkOption {
                      default = null;
                      type = types.str;
                      description = ''
                        Shell commands executed when the instance is starting.
                      '';
                    };
                    options.down = mkOption {
                      default = "";
                      type = types.lines;
                      description = ''
                        Shell commands executed when the instance is shutting down.
                      '';
                    };
                    options.errors-to-stderr = mkOption {
                      default = true;
                      type = types.bool;
                      description = ''
                        Output errors to stderr instead of stdout
                        unless log output is redirected by one of the `--log` options.
                      '';
                    };
                    options.route-up = mkOption {
                      default = "";
                      type = types.lines;
                      description = ''
                        Run command after routes are added.
                      '';
                    };
                    options.up = mkOption {
                      default = "";
                      type = types.lines;
                      description = ''
                        Shell commands executed when the instance is starting.
                      '';
                    };
                    options.script-security = mkOption {
                      default = 1;
                      type = types.enum [
                        1
                        2
                        3
                      ];
                      description = ''
                        - 1 — (Default) Only call built-in executables such as ifconfig, ip, route, or netsh.
                        - 2 — Allow calling of built-in executables and user-defined scripts.
                        - 3 — Allow passwords to be passed to scripts via environmental variables (potentially unsafe).
                      '';
                    };
                  };
                };

                autoStart = mkOption {
                  default = true;
                  type = types.bool;
                  description = "Whether this OpenVPN instance should be started automatically.";
                };

                # Legacy options
                down = (elemAt settings.type.functor.payload.modules 0).options.down;
                up = (elemAt settings.type.functor.payload.modules 0).options.up;

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
                  type = types.nullOr (
                    types.submodule {

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
                    }
                  );
                };

                netns = mkOption {
                  default = null;
                  type = with types; nullOr str;
                  description = "Network namespace.";
                };
              };

              config.settings = mkMerge [
                (mkIf (config.netns != null) {
                  # Useless to setup the interface
                  # because moving it to the netns will reset it
                  ifconfig-noexec = true;
                  route-noexec = true;
                  script-security = 2;
                })
                (mkIf (config.authUserPass != null) {
                  auth-user-pass = pkgs.writeText "openvpn-auth-user-pass-${name}" ''
                    ${config.authUserPass.username}
                    ${config.authUserPass.password}
                  '';
                })
                (mkIf config.updateResolvConf {
                  script-security = 2;
                })
                {
                  # Aliases legacy options
                  down = modules.mkAliasAndWrapDefsWithPriority id (options.down or { });
                  up = modules.mkAliasAndWrapDefsWithPriority id (options.up or { });
                }
              ];

            }
          )
        );

    };

    services.openvpn.restartAfterSleep = mkOption {
      default = true;
      type = types.bool;
      description = "Whether OpenVPN client should be restarted after sleep.";
    };

  };

  ###### implementation

  config = mkIf (enabledServers != { }) {

    systemd.services =
      (listToAttrs (
        mapAttrsToList (
          name: value: nameValuePair "openvpn-${name}" (makeOpenVPNJob value name)
        ) enabledServers
      ))
      // restartService;

    environment.systemPackages = [ openvpn ];

    boot.kernelModules = [ "tun" ];

  };

}
