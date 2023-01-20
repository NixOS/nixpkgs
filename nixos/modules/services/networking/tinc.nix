{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.tinc;

  mkValueString = value:
    if value == true then "yes"
    else if value == false then "no"
    else generators.mkValueStringDefault { } value;

  toTincConf = generators.toKeyValue {
    listsAsDuplicateKeys = true;
    mkKeyValue = generators.mkKeyValueDefault { inherit mkValueString; } "=";
  };

  tincConfType = with types;
    let
      valueType = oneOf [ bool str int ];
    in
    attrsOf (either valueType (listOf valueType));

  addressSubmodule = {
    options = {
      address = mkOption {
        type = types.str;
        description = lib.mdDoc "The external IP address or hostname where the host can be reached.";
      };

      port = mkOption {
        type = types.nullOr types.port;
        default = null;
        description = lib.mdDoc ''
          The port where the host can be reached.

          If no port is specified, the default Port is used.
        '';
      };
    };
  };

  subnetSubmodule = {
    options = {
      address = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          The subnet of this host.

          Subnets can either be single MAC, IPv4 or IPv6 addresses, in which case
          a subnet consisting of only that single address is assumed, or they can
          be a IPv4 or IPv6 network address with a prefix length.

          IPv4 subnets are notated like 192.168.1.0/24, IPv6 subnets are notated
          like fec0:0:0:1::/64. MAC addresses are notated like 0:1a:2b:3c:4d:5e.

          Note that subnets like 192.168.1.1/24 are invalid.
        '';
      };

      prefixLength = mkOption {
        type = with types; nullOr (addCheck int (n: n >= 0 && n <= 128));
        default = null;
        description = lib.mdDoc ''
          The prefix length of the subnet.

          If null, a subnet consisting of only that single address is assumed.

          This conforms to standard CIDR notation as described in RFC1519.
        '';
      };

      weight = mkOption {
        type = types.ints.unsigned;
        default = 10;
        description = lib.mdDoc ''
          Indicates the priority over identical Subnets owned by different nodes.

          Lower values indicate higher priority. Packets will be sent to the
          node with the highest priority, unless that node is not reachable, in
          which case the node with the next highest priority will be tried, and
          so on.
        '';
      };
    };
  };

  hostSubmodule = { config, ... }: {
    options = {
      addresses = mkOption {
        type = types.listOf (types.submodule addressSubmodule);
        default = [ ];
        description = lib.mdDoc ''
          The external address where the host can be reached. This will set this
          host's {option}`settings.Address` option.

          This variable is only required if you want to connect to this host.
        '';
      };

      subnets = mkOption {
        type = types.listOf (types.submodule subnetSubmodule);
        default = [ ];
        description = lib.mdDoc ''
          The subnets which this tinc daemon will serve. This will set this
          host's {option}`settings.Subnet` option.

          Tinc tries to look up which other daemon it should send a packet to by
          searching the appropriate subnet. If the packet matches a subnet, it
          will be sent to the daemon who has this subnet in his host
          configuration file.
        '';
      };

      rsaPublicKey = mkOption {
        type = types.str;
        default = "";
        description = lib.mdDoc ''
          Legacy RSA public key of the host in PEM format, including start and
          end markers.

          This will be appended as-is in the host's configuration file.

          The ed25519 public key can be specified using the
          {option}`settings.Ed25519PublicKey` option instead.
        '';
      };

      settings = mkOption {
        default = { };
        type = types.submodule { freeformType = tincConfType; };
        description = lib.mdDoc ''
          Configuration for this host.

          See <https://tinc-vpn.org/documentation-1.1/Host-configuration-variables.html>
          for supported values.
        '';
      };
    };

    config.settings = {
      Address = mkDefault (map
        (address: "${address.address} ${toString address.port}")
        config.addresses);

      Subnet = mkDefault (map
        (subnet:
          if subnet.prefixLength == null then "${subnet.address}#${toString subnet.weight}"
          else "${subnet.address}/${toString subnet.prefixLength}#${toString subnet.weight}")
        config.subnets);
    };
  };

in
{

  ###### interface

  options = {

    services.tinc = {

      networks = mkOption {
        default = { };
        type = with types; attrsOf (submodule ({ config, ... }: {
          options = {

            extraConfig = mkOption {
              default = "";
              type = types.lines;
              description = lib.mdDoc ''
                Extra lines to add to the tinc service configuration file.

                Note that using the declarative {option}`service.tinc.networks.<name>.settings`
                option is preferred.
              '';
            };

            name = mkOption {
              default = null;
              type = types.nullOr types.str;
              description = lib.mdDoc ''
                The name of the node which is used as an identifier when communicating
                with the remote nodes in the mesh. If null then the hostname of the system
                is used to derive a name (note that tinc may replace non-alphanumeric characters in
                hostnames by underscores).
              '';
            };

            ed25519PrivateKeyFile = mkOption {
              default = null;
              type = types.nullOr types.path;
              description = lib.mdDoc ''
                Path of the private ed25519 keyfile.
              '';
            };

            rsaPrivateKeyFile = mkOption {
              default = null;
              type = types.nullOr types.path;
              description = lib.mdDoc ''
                Path of the private RSA keyfile.
              '';
            };

            debugLevel = mkOption {
              default = 0;
              type = types.addCheck types.int (l: l >= 0 && l <= 5);
              description = lib.mdDoc ''
                The amount of debugging information to add to the log. 0 means little
                logging while 5 is the most logging. {command}`man tincd` for
                more details.
              '';
            };

            hosts = mkOption {
              default = { };
              type = types.attrsOf types.lines;
              description = lib.mdDoc ''
                The name of the host in the network as well as the configuration for that host.
                This name should only contain alphanumerics and underscores.

                Note that using the declarative {option}`service.tinc.networks.<name>.hostSettings`
                option is preferred.
              '';
            };

            hostSettings = mkOption {
              default = { };
              example = literalExpression ''
                {
                  host1 = {
                    addresses = [
                      { address = "192.168.1.42"; }
                      { address = "192.168.1.42"; port = 1655; }
                    ];
                    subnets = [ { address = "10.0.0.42"; } ];
                    rsaPublicKey = "...";
                    settings = {
                      Ed25519PublicKey = "...";
                    };
                  };
                  host2 = {
                    subnets = [ { address = "10.0.1.0"; prefixLength = 24; weight = 2; } ];
                    rsaPublicKey = "...";
                    settings = {
                      Compression = 10;
                    };
                  };
                }
              '';
              type = types.attrsOf (types.submodule hostSubmodule);
              description = lib.mdDoc ''
                The name of the host in the network as well as the configuration for that host.
                This name should only contain alphanumerics and underscores.
              '';
            };

            interfaceType = mkOption {
              default = "tun";
              type = types.enum [ "tun" "tap" ];
              description = lib.mdDoc ''
                The type of virtual interface used for the network connection.
              '';
            };

            listenAddress = mkOption {
              default = null;
              type = types.nullOr types.str;
              description = lib.mdDoc ''
                The ip address to listen on for incoming connections.
              '';
            };

            bindToAddress = mkOption {
              default = null;
              type = types.nullOr types.str;
              description = lib.mdDoc ''
                The ip address to bind to (both listen on and send packets from).
              '';
            };

            package = mkOption {
              type = types.package;
              default = pkgs.tinc_pre;
              defaultText = literalExpression "pkgs.tinc_pre";
              description = lib.mdDoc ''
                The package to use for the tinc daemon's binary.
              '';
            };

            chroot = mkOption {
              default = false;
              type = types.bool;
              description = lib.mdDoc ''
                Change process root directory to the directory where the config file is located (/etc/tinc/netname/), for added security.
                The chroot is performed after all the initialization is done, after writing pid files and opening network sockets.

                Note that this currently breaks dns resolution and tinc can't run scripts anymore (such as tinc-down or host-up), unless it is setup to be runnable inside chroot environment.
              '';
            };

            settings = mkOption {
              default = { };
              type = types.submodule { freeformType = tincConfType; };
              example = literalExpression ''
                {
                  Interface = "custom.interface";
                  DirectOnly = true;
                  Mode = "switch";
                }
              '';
              description = lib.mdDoc ''
                Configuration of the Tinc daemon for this network.

                See <https://tinc-vpn.org/documentation-1.1/Main-configuration-variables.html>
                for supported values.
              '';
            };
          };

          config = {
            hosts = mapAttrs
              (hostname: host: ''
                ${toTincConf host.settings}
                ${host.rsaPublicKey}
              '')
              config.hostSettings;

            settings = {
              DeviceType = mkDefault config.interfaceType;
              Name = mkDefault (if config.name == null then "$HOST" else config.name);
              Ed25519PrivateKeyFile = mkIf (config.ed25519PrivateKeyFile != null) (mkDefault config.ed25519PrivateKeyFile);
              PrivateKeyFile = mkIf (config.rsaPrivateKeyFile != null) (mkDefault config.rsaPrivateKeyFile);
              ListenAddress = mkIf (config.listenAddress != null) (mkDefault config.listenAddress);
              BindToAddress = mkIf (config.bindToAddress != null) (mkDefault config.bindToAddress);
            };
          };
        }));

        description = lib.mdDoc ''
          Defines the tinc networks which will be started.
          Each network invokes a different daemon.
        '';
      };
    };

  };


  ###### implementation

  config = mkIf (cfg.networks != { }) {

    environment.etc = foldr (a: b: a // b) { }
      (flip mapAttrsToList cfg.networks (network: data:
        flip mapAttrs' data.hosts (host: text: nameValuePair
          ("tinc/${network}/hosts/${host}")
          ({ mode = "0644"; user = "tinc.${network}"; inherit text; })
        ) // {
          "tinc/${network}/tinc.conf" = {
            mode = "0444";
            text = ''
              ${toTincConf ({ Interface = "tinc.${network}"; } // data.settings)}
              ${data.extraConfig}
            '';
          };
        }
      ));

    systemd.services = flip mapAttrs' cfg.networks (network: data: nameValuePair
      ("tinc.${network}")
      ({
        description = "Tinc Daemon - ${network}";
        wantedBy = [ "multi-user.target" ];
        path = [ data.package ];
        restartTriggers = [ config.environment.etc."tinc/${network}/tinc.conf".source ];
        serviceConfig = {
          Type = "simple";
          Restart = "always";
          RestartSec = "3";
          ExecReload = mkIf (versionAtLeast (getVersion data.package) "1.1pre") "${data.package}/bin/tinc -n ${network} reload";
          ExecStart = "${data.package}/bin/tincd -D -U tinc.${network} -n ${network} ${optionalString (data.chroot) "-R"} --pidfile /run/tinc.${network}.pid -d ${toString data.debugLevel}";
        };
        preStart = ''
          mkdir -p /etc/tinc/${network}/hosts
          chown tinc.${network} /etc/tinc/${network}/hosts
          mkdir -p /etc/tinc/${network}/invitations
          chown tinc.${network} /etc/tinc/${network}/invitations

          # Determine how we should generate our keys
          if type tinc >/dev/null 2>&1; then
            # Tinc 1.1+ uses the tinc helper application for key generation
          ${if data.ed25519PrivateKeyFile != null then "  # ed25519 Keyfile managed by nix" else ''
            # Prefer ED25519 keys (only in 1.1+)
            [ -f "/etc/tinc/${network}/ed25519_key.priv" ] || tinc -n ${network} generate-ed25519-keys
          ''}
          ${if data.rsaPrivateKeyFile != null then "  # RSA Keyfile managed by nix" else ''
            [ -f "/etc/tinc/${network}/rsa_key.priv" ] || tinc -n ${network} generate-rsa-keys 4096
          ''}
            # In case there isn't anything to do
            true
          else
            # Tinc 1.0 uses the tincd application
            [ -f "/etc/tinc/${network}/rsa_key.priv" ] || tincd -n ${network} -K 4096
          fi
        '';
      })
    );

    environment.systemPackages = let
      cli-wrappers = pkgs.stdenv.mkDerivation {
        name = "tinc-cli-wrappers";
        buildInputs = [ pkgs.makeWrapper ];
        buildCommand = ''
          mkdir -p $out/bin
          ${concatStringsSep "\n" (mapAttrsToList (network: data:
            optionalString (versionAtLeast data.package.version "1.1pre") ''
              makeWrapper ${data.package}/bin/tinc "$out/bin/tinc.${network}" \
                --add-flags "--pidfile=/run/tinc.${network}.pid" \
                --add-flags "--config=/etc/tinc/${network}"
            '') cfg.networks)}
        '';
      };
    in [ cli-wrappers ];

    users.users = flip mapAttrs' cfg.networks (network: _:
      nameValuePair ("tinc.${network}") ({
        description = "Tinc daemon user for ${network}";
        isSystemUser = true;
        group = "tinc.${network}";
      })
    );
    users.groups = flip mapAttrs' cfg.networks (network: _:
      nameValuePair "tinc.${network}" {}
    );
  };

  meta.maintainers = with maintainers; [ minijackson mic92 ];
}
