{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.tinc;

in

{

  ###### interface

  options = {

    services.tinc = {

      networks = mkOption {
        default = { };
        type = with types; attrsOf (submodule {
          options = {

            extraConfig = mkOption {
              default = "";
              type = types.lines;
              description = ''
                Extra lines to add to the tinc service configuration file.
              '';
            };

            name = mkOption {
              default = null;
              type = types.nullOr types.str;
              description = ''
                The name of the node which is used as an identifier when communicating
                with the remote nodes in the mesh. If null then the hostname of the system
                is used to derive a name (note that tinc may replace non-alphanumeric characters in
                hostnames by underscores).
              '';
            };

            ed25519PrivateKeyFile = mkOption {
              default = null;
              type = types.nullOr types.path;
              description = ''
                Path of the private ed25519 keyfile.
              '';
            };

            debugLevel = mkOption {
              default = 0;
              type = types.addCheck types.int (l: l >= 0 && l <= 5);
              description = ''
                The amount of debugging information to add to the log. 0 means little
                logging while 5 is the most logging. <command>man tincd</command> for
                more details.
              '';
            };

            hosts = mkOption {
              default = { };
              type = types.attrsOf types.lines;
              description = ''
                The name of the host in the network as well as the configuration for that host.
                This name should only contain alphanumerics and underscores.
              '';
            };

            interfaceType = mkOption {
              default = "tun";
              type = types.enum [ "tun" "tap" ];
              description = ''
                The type of virtual interface used for the network connection
              '';
            };

            listenAddress = mkOption {
              default = null;
              type = types.nullOr types.str;
              description = ''
                The ip address to listen on for incoming connections.
              '';
            };

            bindToAddress = mkOption {
              default = null;
              type = types.nullOr types.str;
              description = ''
                The ip address to bind to (both listen on and send packets from).
              '';
            };

            package = mkOption {
              type = types.package;
              default = pkgs.tinc_pre;
              defaultText = "pkgs.tinc_pre";
              description = ''
                The package to use for the tinc daemon's binary.
              '';
            };

            chroot = mkOption {
              default = true;
              type = types.bool;
              description = ''
                Change process root directory to the directory where the config file is located (/etc/tinc/netname/), for added security.
                The chroot is performed after all the initialization is done, after writing pid files and opening network sockets.

                Note that tinc can't run scripts anymore (such as tinc-down or host-up), unless it is setup to be runnable inside chroot environment.
              '';
            };
          };
        });

        description = ''
          Defines the tinc networks which will be started.
          Each network invokes a different daemon.
        '';
      };
    };

  };


  ###### implementation

  config = mkIf (cfg.networks != { }) {

    environment.etc = fold (a: b: a // b) { }
      (flip mapAttrsToList cfg.networks (network: data:
        flip mapAttrs' data.hosts (host: text: nameValuePair
          ("tinc/${network}/hosts/${host}")
          ({ mode = "0644"; user = "tinc.${network}"; inherit text; })
        ) // {
          "tinc/${network}/tinc.conf" = {
            mode = "0444";
            text = ''
              Name = ${if data.name == null then "$HOST" else data.name}
              DeviceType = ${data.interfaceType}
              ${optionalString (data.ed25519PrivateKeyFile != null) "Ed25519PrivateKeyFile = ${data.ed25519PrivateKeyFile}"}
              ${optionalString (data.listenAddress != null) "ListenAddress = ${data.listenAddress}"}
              ${optionalString (data.bindToAddress != null) "BindToAddress = ${data.bindToAddress}"}
              Device = /dev/net/tun
              Interface = tinc.${network}
              ${data.extraConfig}
            '';
          };
        }
      ));

    networking.interfaces = flip mapAttrs' cfg.networks (network: data: nameValuePair
      ("tinc.${network}")
      ({
        virtual = true;
        virtualType = "${data.interfaceType}";
      })
    );

    systemd.services = flip mapAttrs' cfg.networks (network: data: nameValuePair
      ("tinc.${network}")
      ({
        description = "Tinc Daemon - ${network}";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        path = [ data.package ];
        serviceConfig = {
          Type = "simple";
          Restart = "always";
          RestartSec = "3";
        };
        preStart = ''
          mkdir -p /etc/tinc/${network}/hosts
          chown tinc.${network} /etc/tinc/${network}/hosts

          # Determine how we should generate our keys
          if type tinc >/dev/null 2>&1; then
            # Tinc 1.1+ uses the tinc helper application for key generation
          ${if data.ed25519PrivateKeyFile != null then "  # Keyfile managed by nix" else ''
            # Prefer ED25519 keys (only in 1.1+)
            [ -f "/etc/tinc/${network}/ed25519_key.priv" ] || tinc -n ${network} generate-ed25519-keys
          ''}
            # Otherwise use RSA keys
            [ -f "/etc/tinc/${network}/rsa_key.priv" ] || tinc -n ${network} generate-rsa-keys 4096
          else
            # Tinc 1.0 uses the tincd application
            [ -f "/etc/tinc/${network}/rsa_key.priv" ] || tincd -n ${network} -K 4096
          fi
        '';
        script = ''
          tincd -D -U tinc.${network} -n ${network} ${optionalString (data.chroot) "-R"} --pidfile /run/tinc.${network}.pid -d ${toString data.debugLevel}
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
                --add-flags "--pidfile=/run/tinc.${network}.pid"
            '') cfg.networks)}
        '';
      };
    in [ cli-wrappers ];

    users.extraUsers = flip mapAttrs' cfg.networks (network: _:
      nameValuePair ("tinc.${network}") ({
        description = "Tinc daemon user for ${network}";
        isSystemUser = true;
      })
    );

  };

}
