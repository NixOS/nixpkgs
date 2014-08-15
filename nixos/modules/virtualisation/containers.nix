{ config, lib, pkgs, ... }:

with lib;

let

  nixos-container = pkgs.substituteAll {
    name = "nixos-container";
    dir = "bin";
    isExecutable = true;
    src = ./nixos-container.pl;
    perl = "${pkgs.perl}/bin/perl -I${pkgs.perlPackages.FileSlurp}/lib/perl5/site_perl";
    inherit (pkgs) socat;
  };

  # The container's init script, a small wrapper around the regular
  # NixOS stage-2 init script.
  containerInit = pkgs.writeScript "container-init"
    ''
      #! ${pkgs.stdenv.shell} -e

      # Initialise the container side of the veth pair.
      if [ "$PRIVATE_NETWORK" = 1 ]; then
        ip link set host0 name eth0
        ip link set dev eth0 up
        if [ -n "$HOST_ADDRESS" ]; then
          ip route add $HOST_ADDRESS dev eth0
          ip route add default via $HOST_ADDRESS
        fi
        if [ -n "$LOCAL_ADDRESS" ]; then
          ip addr add $LOCAL_ADDRESS dev eth0
        fi
      fi

      exec "$1"
    '';

  system = config.nixpkgs.system;

in

{
  options = {

    boot.isContainer = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether this NixOS machine is a lightweight container running
        in another NixOS system.
      '';
    };

    containers = mkOption {
      type = types.attrsOf (types.submodule (
        { config, options, name, ... }:
        {
          options = {

            config = mkOption {
              description = ''
                A specification of the desired configuration of this
                container, as a NixOS module.
              '';
            };

            path = mkOption {
              type = types.path;
              example = "/nix/var/nix/profiles/containers/webserver";
              description = ''
                As an alternative to specifying
                <option>config</option>, you can specify the path to
                the evaluated NixOS system configuration, typically a
                symlink to a system profile.
              '';
            };

            privateNetwork = mkOption {
              type = types.bool;
              default = false;
              description = ''
                Whether to give the container its own private virtual
                Ethernet interface.  The interface is called
                <literal>eth0</literal>, and is hooked up to the interface
                <literal>ve-<replaceable>container-name</replaceable></literal>
                on the host.  If this option is not set, then the
                container shares the network interfaces of the host,
                and can bind to any port on any interface.
              '';
            };

            hostAddress = mkOption {
              type = types.nullOr types.string;
              default = null;
              example = "10.231.136.1";
              description = ''
                The IPv4 address assigned to the host interface.
              '';
            };

            localAddress = mkOption {
              type = types.nullOr types.string;
              default = null;
              example = "10.231.136.2";
              description = ''
                The IPv4 address assigned to <literal>eth0</literal>
                in the container.
              '';
            };

          };

          config = mkMerge
            [ (mkIf options.config.isDefined {
                path = (import ../../lib/eval-config.nix {
                  inherit system;
                  modules =
                    let extraConfig =
                      { boot.isContainer = true;
                        networking.hostName = mkDefault name;
                        networking.useDHCP = false;
                      };
                    in [ extraConfig config.config ];
                  prefix = [ "containers" name ];
                }).config.system.build.toplevel;
              })
            ];
        }));

      default = {};
      example = literalExample
        ''
          { webserver =
              { path = "/nix/var/nix/profiles/webserver";
              };
            database =
              { config =
                  { config, pkgs, ... }:
                  { services.postgresql.enable = true;
                    services.postgresql.package = pkgs.postgresql92;
                  };
              };
          }
        '';
      description = ''
        A set of NixOS system configurations to be run as lightweight
        containers.  Each container appears as a service
        <literal>container-<replaceable>name</replaceable></literal>
        on the host system, allowing it to be started and stopped via
        <command>systemctl</command> .
      '';
    };

  };


  config = mkIf (!config.boot.isContainer) {

    systemd.services."container@" =
      { description = "Container '%i'";

        unitConfig.RequiresMountsFor = [ "/var/lib/containers/%i" ];

        path = [ pkgs.iproute ];

        environment.INSTANCE = "%i";
        environment.root = "/var/lib/containers/%i";

        preStart =
          ''
            mkdir -p -m 0755 $root/var/lib

            # Create a named pipe to get a signal when the container
            # has finished booting.
            rm -f $root/var/lib/startup-done
            mkfifo -m 0600 $root/var/lib/startup-done
         '';

        script =
          ''
            mkdir -p -m 0755 "$root/etc" "$root/var/lib"
            if ! [ -e "$root/etc/os-release" ]; then
              touch "$root/etc/os-release"
            fi

            mkdir -p -m 0755 \
              "/nix/var/nix/profiles/per-container/$INSTANCE" \
              "/nix/var/nix/gcroots/per-container/$INSTANCE"

            cp -f /etc/resolv.conf "$root/etc/resolv.conf"

            if [ "$PRIVATE_NETWORK" = 1 ]; then
              extraFlags+=" --network-veth"
            fi

            for iface in $MACVLANS; do
              extraFlags+=" --network-macvlan=$iface"
            done

            # If the host is 64-bit and the container is 32-bit, add a
            # --personality flag.
            ${optionalString (config.nixpkgs.system == "x86_64-linux") ''
              if [ "$(< ''${SYSTEM_PATH:-/nix/var/nix/profiles/per-container/$INSTANCE/system}/system)" = i686-linux ]; then
                extraFlags+=" --personality=x86"
              fi
            ''}

            exec ${config.systemd.package}/bin/systemd-nspawn \
              --keep-unit \
              -M "$INSTANCE" -D "$root" $extraFlags \
              --bind-ro=/nix/store \
              --bind-ro=/nix/var/nix/db \
              --bind-ro=/nix/var/nix/daemon-socket \
              --bind="/nix/var/nix/profiles/per-container/$INSTANCE:/nix/var/nix/profiles" \
              --bind="/nix/var/nix/gcroots/per-container/$INSTANCE:/nix/var/nix/gcroots" \
              --setenv PRIVATE_NETWORK="$PRIVATE_NETWORK" \
              --setenv HOST_ADDRESS="$HOST_ADDRESS" \
              --setenv LOCAL_ADDRESS="$LOCAL_ADDRESS" \
              --setenv PATH="$PATH" \
              ${containerInit} "''${SYSTEM_PATH:-/nix/var/nix/profiles/system}/init"
          '';

        postStart =
          ''
            # This blocks until the container-startup-done service
            # writes something to this pipe.  FIXME: it also hangs
            # until the start timeout expires if systemd-nspawn exits.
            read x < $root/var/lib/startup-done
            rm -f $root/var/lib/startup-done

            if [ "$PRIVATE_NETWORK" = 1 ]; then
              ifaceHost=ve-$INSTANCE
              ip link set dev $ifaceHost up
              if [ -n "$HOST_ADDRESS" ]; then
                ip addr add $HOST_ADDRESS dev $ifaceHost
              fi
              if [ -n "$LOCAL_ADDRESS" ]; then
                ip route add $LOCAL_ADDRESS dev $ifaceHost
              fi
            fi
          '';

        preStop =
          ''
            machinectl poweroff "$INSTANCE"
          '';

        restartIfChanged = false;
        #reloadIfChanged = true; # FIXME

        serviceConfig.ExecReload = pkgs.writeScript "reload-container"
          ''
            #! ${pkgs.stdenv.shell} -e
            SYSTEM_PATH=/nix/var/nix/profiles/system
            echo $SYSTEM_PATH/bin/switch-to-configuration test | \
              ${pkgs.socat}/bin/socat unix:$root/var/lib/run-command.socket -
          '';

        serviceConfig.SyslogIdentifier = "container %i";

        serviceConfig.EnvironmentFile = "-/etc/containers/%i.conf";
      };

    # Generate a configuration file in /etc/containers for each
    # container so that container@.target can get the container
    # configuration.
    environment.etc = mapAttrs' (name: cfg: nameValuePair "containers/${name}.conf"
      { text =
          ''
            SYSTEM_PATH=${cfg.path}
            ${optionalString cfg.privateNetwork ''
              PRIVATE_NETWORK=1
              ${optionalString (cfg.hostAddress != null) ''
                HOST_ADDRESS=${cfg.hostAddress}
              ''}
              ${optionalString (cfg.localAddress != null) ''
                LOCAL_ADDRESS=${cfg.localAddress}
              ''}
            ''}
          '';
      }) config.containers;

    # FIXME: auto-start containers.

    # Generate /etc/hosts entries for the containers.
    networking.extraHosts = concatStrings (mapAttrsToList (name: cfg: optionalString (cfg.localAddress != null)
      ''
        ${cfg.localAddress} ${name}.containers
      '') config.containers);

    networking.dhcpcd.denyInterfaces = [ "ve-*" ];

    environment.systemPackages = [ nixos-container ];

  };
}
