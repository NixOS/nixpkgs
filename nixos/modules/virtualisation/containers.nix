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
    ''#! ${pkgs.stdenv.shell} -e
      
      # Initialise the container side of the veth pair.
      if [ -n "$HOST_ADDRESS" ] || [ -n "$LOCAL_ADDRESS" ]; then
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

      # Initialise the container side of the macvlan interface.
      if [ -n "$MACVLANS" ]; then
      ip link set mv-$MACVLANS name eth1
        ip link set dev eth1 up
        if [ -n "$MACVLAN_ADDRESS" ]; then
          ip addr add $MACVLAN_ADDRESS dev eth1
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
                Whether to give the container its own private network namespace.  
                This option is implied if setting <option>hostAddress</option>,
                <option>localAddress</option> or <option>macvlanInterface</option>
                If this option is not set, then the container shares the network 
                interfaces of the host, and can bind to any port on any interface.
              '';
            };

            hostAddress = mkOption {
              type = types.nullOr types.string;
              default = null;
              example = "10.231.136.1";
              description = ''
                The IPv4 address assigned to the host-side of a veth pair.
                Setting <option>hostAddress</option> or <option>localAddress</option>
                will create a veth pair with one side in the container appearing as 
                <literal>eth0</literal>, and the other side in the host as 
                <literal>ve-<replaceable>container-name</replaceable></literal>.
              '';
            };

            localAddress = mkOption {
              type = types.nullOr types.string;
              default = null;
              example = "10.231.136.2";
              description = ''
                The IPv4 address assigned to the container-side of a veth pair
                (<literal>eth0</literal> in the container).
                Setting <option>hostAddress</option> or <option>localAddress</option>
                will create a veth pair with one side in the container appearing as 
                <literal>eth0</literal>, and the other side in the host as 
                <literal>ve-<replaceable>container-name</replaceable></literal>.
              '';
            };

            macvlanInterface = mkOption {
              type = types.nullOr types.string;
              default = null;
              example = "enp1s1";
              description = ''
                When this option is set an <literal>eth1</literal> interface
                will be available within the container that bridges to the host's
                physical network using macvlan.
                Note: while macvlan interfaces allow your containers to be accessable 
                via the the same physical network as the specified host interface, you 
                may not be able to communicate between the host itself and container.
              '';
            };
      
            macvlanAddress = mkOption {
              type = types.nullOr types.string;
              default = null;
              example = "10.231.136.2";
              description = ''
                The IPv4 address assigned to <literal>eth1</literal>
                (the macvlan interface) in the container.
              '';
            };

            macvlanPrefixLength = mkOption {
              type = types.nullOr types.int;
              default = 32;
              example = 16;
              description = ''
                The network prefix length for the macvlan interface.
              '';
            };

            wantedBy = mkOption {
              type = types.listOf types.str;
              default = [ "multi-user.target" ];
              description = ''
                List of systemd units/targets that should cause this
                container to start. Set to <literal>[]</literal> if
                you do not want this container to start.
              '';
            };

            linkJournal = mkOption {
              type = types.enum [ "auto" "host" "guest" "no" ];
              default = "auto";
              description = ''
                Control whether the container's journal shall be made 
				visible to the host to allow viewing the container's 
				journal files from the host (but not vice versa). 
				Takes one of "no", "host", "guest", "auto". If "no", 
				the journal is not linked. If "host", the journal files 
				are stored on the host file system (beneath /var/log/journal/machine-id) 
				and the subdirectory is bind-mounted into the container 
				at the same location. If "guest", the journal files are 
				stored on the guest file system (beneath /var/log/journal/machine-id) 
				and the subdirectory is symlinked into the host at the 
				same location. If "auto" (the default), and the subdirectory of 
				/var/log/journal/machine-id exists, it will be bind mounted 
				into the container. If the subdirectory does not exist, no 
				linking is performed. Effectively, booting a container once 
				with "guest" or "host" will link the journal persistently 
				if further on the default of "auto" is used.
              '';
            };

            grantCapabilities = mkOption {
              type = types.listOf types.str;
              default = [];
			  example = [ "CAP_MKNOD" ];
              description = ''
				List of additional capabilities to grant the container.
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


  config = mkIf (!config.boot.isContainer) (let
  
    unit = { 

      description = "Container '%i'";

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

            if [ "$PRIVATE_NETWORK" = 1 ]; then
              extraFlags+=" --private-network"
            fi

            if [ -n "$HOST_ADDRESS" ] || [ -n "$LOCAL_ADDRESS" ]; then
              extraFlags+=" --network-veth"
            fi

            for iface in $MACVLANS; do
              extraFlags+=" --network-macvlan=$iface"
            done

			if [ -n "$GRANT_CAPS" ]; then
			  extraFlags+=" --capability=$GRANT_CAPS"
			fi

            # If the host is 64-bit and the container is 32-bit, add a
            # --personality flag.
            '' + optionalString (config.nixpkgs.system == "x86_64-linux") ''
              if [ "$(< ''${SYSTEM_PATH:-/nix/var/nix/profiles/per-container/$INSTANCE/system}/system)" = i686-linux ]; then
                extraFlags+=" --personality=x86"
              fi
            '' + ''

            exec ${config.systemd.package}/bin/systemd-nspawn \
              --keep-unit \
              -M "$INSTANCE" -D "$root" $extraFlags \
			  --link-journal=''${LINK_JOURNAL:-auto} \
              --bind-ro=/nix/store \
              --bind-ro=/nix/var/nix/db \
              --bind-ro=/nix/var/nix/daemon-socket \
              --bind="/nix/var/nix/profiles/per-container/$INSTANCE:/nix/var/nix/profiles" \
              --bind="/nix/var/nix/gcroots/per-container/$INSTANCE:/nix/var/nix/gcroots" \
              --setenv PRIVATE_NETWORK="$PRIVATE_NETWORK" \
              --setenv HOST_ADDRESS="$HOST_ADDRESS" \
              --setenv LOCAL_ADDRESS="$LOCAL_ADDRESS" \
              --setenv MACVLANS="$MACVLANS" \
              --setenv MACVLAN_ADDRESS="$MACVLAN_ADDRESS" \
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

            if [ -n "$HOST_ADDRESS" ] || [ -n "$LOCAL_ADDRESS" ]; then
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

      # TODO: If the network configuration has changed, then trigger a full reboot of the
      # container to setup the new interfaces, otherwise just rebuild the config
      # within the container without restarting.
      serviceConfig.ExecReload = pkgs.writeScript "reload-container"
          ''#!${pkgs.stdenv.shell}
            SYSTEM_PATH="''${SYSTEM_PATH:-/nix/var/nix/profiles/system}"
            echo $SYSTEM_PATH/bin/switch-to-configuration test | \
              ${pkgs.socat}/bin/socat unix:$root/var/lib/run-command.socket -
          '';

      serviceConfig.SyslogIdentifier = "container %i";

      serviceConfig.EnvironmentFile = "-/etc/containers/%i.conf";

    };

  in {

    systemd.services = listToAttrs (
      # The generic container template used by imperative containers
      [{ name = "container@"; value = unit; }]
      # declarative containers 
      ++ (mapAttrsToList (name: cfg: nameValuePair "container@${name}" (
        unit // {
          wantedBy = cfg.wantedBy;
          wants = [ "network.target" ];
          after = [ "network.target" ];
          restartTriggers = [ cfg.path ];
          reloadIfChanged = true;
        }
      )) config.containers));

    # Generate a configuration file in /etc/containers for each
    # container so that container@.target can get the container
    # configuration.
    environment.etc = mapAttrs' (name: cfg: nameValuePair "containers/${name}.conf" { 
      text = 
      ''
      SYSTEM_PATH=${cfg.path}
      '' 
      + (optionalString ( cfg.privateNetwork 
                       || cfg.localAddress!=null
                       || cfg.hostAddress!=null
                       || cfg.macvlanInterface!=null)
        ''
        PRIVATE_NETWORK=1
        '')
      + (optionalString (cfg.hostAddress != null) 
        ''
        HOST_ADDRESS=${cfg.hostAddress}
        '')
      + (optionalString (cfg.localAddress != null) 
        ''
        LOCAL_ADDRESS=${cfg.localAddress}
        '')
      + (optionalString (cfg.macvlanInterface != null) 
        ''
        MACVLANS=${cfg.macvlanInterface}
        '')
      + (optionalString (cfg.macvlanAddress != null) 
        ''
        MACVLAN_ADDRESS=${cfg.macvlanAddress}/${toString cfg.macvlanPrefixLength}
        '')
      + (optionalString (cfg.linkJournal != null) 
        ''
        LINK_JOURNAL=${cfg.linkJournal}
        '')
      + (optionalString (length cfg.grantCapabilities > 0) 
        ''
        GRANT_CAPS=${concatStringsSep "," cfg.grantCapabilities}
        '');
    }) config.containers;

    # Generate /etc/hosts entries for the containers.
    networking.extraHosts = concatStrings (mapAttrsToList (name: cfg: optionalString (cfg.localAddress != null)
      ''
        ${cfg.localAddress} ${name}.containers
      '') config.containers);

    networking.dhcpcd.denyInterfaces = [ "ve-*" ];

    environment.systemPackages = [ nixos-container ];

  });
}
