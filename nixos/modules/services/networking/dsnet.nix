{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.dsnet;
  settingsFormat = pkgs.formats.json { };
  patchFile = settingsFormat.generate "dsnet-patch.json" cfg.settings;
in
{
  options.services.dsnet = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable dsnet as a systemd service.";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = (pkgs.callPackage ./dsnet.nix { });
      description = "The dsnet package to use.";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {

        freeformType = settingsFormat.type;

        options = {
          ExternalHostname = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "vpn.example.com";
            description = ''
              The hostname that clients should use to connect to this server.
              This is used to generate the client configuration files.

              This is preferred over ExternalIP, as it allows for IPv4 and
              IPv6, as well as enabling the ability tp change IP.
            '';
          };

          ExternalIP = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "192.0.2.1";
            description = ''
              The external IP address of the server. This is used to generate
              the client configuration files for when an ExternalHostname is not set.

              Leaving this empty will cause dsnet to use the IP address of
              what looks like the WAN interface.
            '';
          };

          ExternalIP6 = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "2001:db8::1";
            description = ''
              The external IPv6 address of the server. This is used to generate
              the client configuration files for when an ExternalHostname is
              not set. Used in preference to ExternalIP.

              Leaving this empty will cause dsnet to use the IP address of
              what looks like the WAN interface.
            '';
          };

          ListenPort = lib.mkOption {
            type = lib.types.nullOr lib.types.int;
            default = null;
            example = 51820;
            description = ''
              The port that the server will listen on. This is used to generate
              the client configuration file as well as configure wireguard itself.
            '';
          };

          Domain = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "example.com";
            description = ''
              Internal domain name for clients. This is for information only
              and available in the dsnet report. Useful to facilitate dynamic
              DNS.
            '';
          };

          InterfaceName = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "dsnet";
            description = ''
              The name of the interface that dsnet will create. This is used to
              generate the client configuration files.
            '';
          };

          Network = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "172.18.0.0/24";
            description = ''
              The IPv4 network that the server will use to allocate IPs on the network.
              Leave this empty to let dsnet choose a network.
            '';
          };

          Network6 = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "2001:db8::1/64";
            description = ''
              The IPv6 network that the server will use to allocate IPs on the
              network.
              Leave this empty to let dsnet choose a network.
            '';
          };

          IP = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "172.18.0.1";
            description = ''
              The IPv4 address that the server will use on the network.
              Leave this empty to let dsnet choose an address.
            '';
          };

          IP6 = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "2001:db8::1";
            description = ''
              The IPv6 address that the server will use on the network
              Leave this empty to let dsnet choose an address.
            '';
          };

          Networks = lib.mkOption {
            type = lib.types.nullOr (lib.types.listOf lib.types.str);
            default = null;
            example = [
              "0.0.0.0/0"
              "192.168.0.0/24"
            ];
            description = ''
              The CIDR networks that should route through this server. Clients
              will be configured to route traffic for these networks through
              the server peer.
            '';
          };

          PrivateKey = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "c908j1sT3MIs4ac/mIwaiXn9/2CpI4HwcMX9WYXWUHc=";
            description = ''
              The private key that the server will use to authenticate itself
              to the clients. This is used to generate the client configuration
              files. It is recommended to leave this unconfigured to let dsnet
              handle the generation and key management.

              Leave this empty to let dsnet generate a key.
            '';
          };

          PostUp = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "\${pkgs.iptables} -A FORWARD -i %i -j ACCEPT";
            description = ''
              The command to run after the interface is up. This is normally
              used to configure the firewall rules for the interface, for
              instance SNAT masquerading.
            '';
          };

          PostDown = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "\${pkgs.iptables} -D FORWARD -i %i -j ACCEPT";
            description = ''
              The command to run after the interface is down. This is normally
              used to configure the firewall rules for the interface.
            '';
          };

          Peers = lib.mkOption {
            type = lib.types.nullOr (
              lib.types.listOf (
                lib.types.submodule {
                  freeformType = settingsFormat.type;
                  options = {
                    Hostname = lib.mkOption {
                      type = lib.types.str;
                      example = "picard";
                      description = ''
                        The simple hostname of the peer. For information only, could
                        be used to integrate dynamic DNS
                      '';
                    };
                    Owner = lib.mkOption {
                      type = lib.types.str;
                      example = "naggie";
                      description = ''
                        The owner of the peer. This is for information only and
                        available in the dsnet report.
                      '';
                    };
                    Description = lib.mkOption {
                      type = lib.types.str;
                      example = "My laptop";
                      description = ''
                        A description of the peer. This is for information only and
                        available in the dsnet report.
                      '';
                    };
                    IP = lib.mkOption {
                      type = lib.types.str;
                      example = "192.168.1.2";
                      description = ''
                        The IP address that the peer will use on the network. This is
                        used to generate the client configuration files and configure wireguard
                      '';
                    };
                    IP6 = lib.mkOption {
                      type = lib.types.str;
                      example = "2001:db8::2";
                      description = ''
                        The IPv6 address that the peer will use on the network. This
                        is used to generate the client configuration files and
                        configure wireguard.
                      '';
                    };
                    Added = lib.mkOption {
                      type = lib.types.str;
                      example = "2025-05-06T15:34:38.946806057+01:00";
                      description = ''
                        ISO8601 date that the peer was added. This is for information only
                        and available in the dsnet report.
                      '';
                    };
                    Networks = lib.mkOption {
                      type = lib.types.listOf lib.types.str;
                      example = [ "192.168.0.0/22" ];
                      description = ''
                        The CIDR networks that could route through this server. Not
                        currently used, for information only.
                      '';
                    };
                    PublicKey = lib.mkOption {
                      type = lib.types.str;
                      default = "";
                      example = "c908j1sT3MIs4ac/mIwaiXn9/2CpI4HwcMX9WYXWUHc=";
                      description = ''
                        The public key of the peer
                      '';
                    };
                    PresharedKey = lib.mkOption {
                      type = lib.types.str;
                      default = "";
                      example = "c908j1sT3MIs4ac/mIwaiXn9/2CpI4HwcMX9WYXWUHc=";
                      description = ''
                        The preshared key of the peer/server combination
                      '';
                    };
                  };
                }
              )
            );

            default = null;
            description = ''
              If you want to manage the peers from NixOS configuration, you can
              add them here. This is not recommended as it negates the purpose
              of dsnet in the first place.

              If this is populated, like other values it will override any
              existing peers.
            '';
          };

          PersistentKeepalive = lib.mkOption {
            type = lib.types.nullOr lib.types.int;
            default = null;
            example = 25;
            description = ''
              The persistent keepalive interval for the peer. This is used to
              keep the connection alive when there is no traffic. This is
              recommended to be set to 25 seconds.
            '';
          };
        };
      };

      default = { };
      description = ''
        The settings to use for dsnet. This will be converted to a JSON
        object that will be passed to dsnet as a patch, using the patch
        command when the service is started. See the dsnet documentation for
        more information on the available options.

        Note that the resulting /etc/dsnetconfg.json is more of a database
        than it is a configuration file. It is therefore recommended that
        system specific values are configured here, rather than the full
        configuration including peers.

        Peers may be managed via the dsnet add/remove commands, negating the
        need to manage key material and cumbersom configuration with nix. If
        you want peer configuration in nix, you may as well use the regular
        wireguard module.
      '';
      example = lib.literalExpression ''
        {
            "ExternalHostname": "vpn.example.com";
            "ExternalIP": "127.0.0.1";
            "ExternalIP6": "";
            "ListenPort": 51820;
            "Network": "10.3.148.0/22";
            "Network6": "",
            "IP": "10.3.148.1";
            "IP6": "";
            "DNS": "8.8.8.8";
            "Networks": ["0.0.0.0/0"];
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.dsnet = {
      description = "dsnet VPN Management";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        test ! -f /etc/dsnetconfig.json && ${cfg.package}/bin/dsnet init
        cat ${patchFile} | ${cfg.package}/bin/dsnet patch
      '';
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/dsnet up";
        ExecStop = "${cfg.package}/bin/dsnet down";
        Type = "oneshot";
        # consider the service to be active after process exits, so it can be
        # reloaded
        RemainAfterExit = true;
      };

      reload = ''
        cat ${patchFile} | ${cfg.package}/bin/dsnet patch
        cat ${patchFile} | ${cfg.package}/bin/dsnet sync
      '';

      # reload _instead_ of restarting on change
      reloadIfChanged = true;
    };
  };
}
