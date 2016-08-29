{ config, lib, pkgs, ... }:

with lib;

let

  # The container's init script, a small wrapper around the regular
  # NixOS stage-2 init script.
  containerInit = (cfg:
    let
      renderExtraVeth = (name: cfg:
        ''
        echo "Bringing ${name} up"
        ip link set dev ${name} up
        ${optionalString (cfg . "localAddress" or null != null) ''
          echo "Setting ip for ${name}"
          ip addr add ${cfg . "localAddress"} dev ${name}
        ''}
        ${optionalString (cfg . "localAddress6" or null != null) ''
          echo "Setting ip6 for ${name}"
          ip -6 addr add ${cfg . "localAddress6"} dev ${name}
        ''}
        ${optionalString (cfg . "hostAddress" or null != null) ''
          echo "Setting route to host for ${name}"
          ip route add ${cfg . "hostAddress"} dev ${name}
        ''}
        ${optionalString (cfg . "hostAddress6" or null != null) ''
          echo "Setting route6 to host for ${name}"
          ip -6 route add ${cfg . "hostAddress6"} dev ${name}
        ''}
        ''
        );
    in
      pkgs.writeScript "container-init"
      ''
        #! ${pkgs.stdenv.shell} -e

        # Initialise the container side of the veth pair.
        if [ "$PRIVATE_NETWORK" = 1 ]; then

          ip link set host0 name eth0
          ip link set dev eth0 up

          if [ -n "$LOCAL_ADDRESS" ]; then
            ip addr add $LOCAL_ADDRESS dev eth0
          fi
          if [ -n "$LOCAL_ADDRESS6" ]; then
            ip -6 addr add $LOCAL_ADDRESS6 dev eth0
          fi
          if [ -n "$HOST_ADDRESS" ]; then
            ip route add $HOST_ADDRESS dev eth0
            ip route add default via $HOST_ADDRESS
          fi
          if [ -n "$HOST_ADDRESS6" ]; then
            ip -6 route add $HOST_ADDRESS6 dev eth0
            ip -6 route add default via $HOST_ADDRESS6
          fi

          ${concatStringsSep "\n" (mapAttrsToList renderExtraVeth cfg . "extraVeths" or {})}
          ip a
          ip r
        fi

        # Start the regular stage 1 script.
        exec "$1"
      ''
    );

  nspawnExtraVethArgs = (name: cfg: "--network-veth-extra=${name}");
  startScript = (cfg:
    ''
      mkdir -p -m 0755 "$root/etc" "$root/var/lib"
      mkdir -p -m 0700 "$root/var/lib/private" "$root/root" /run/containers
      if ! [ -e "$root/etc/os-release" ]; then
        touch "$root/etc/os-release"
      fi

      if ! [ -e "$root/etc/machine-id" ]; then
        touch "$root/etc/machine-id"
      fi

      mkdir -p -m 0755 \
        "/nix/var/nix/profiles/per-container/$INSTANCE" \
        "/nix/var/nix/gcroots/per-container/$INSTANCE"

      cp --remove-destination /etc/resolv.conf "$root/etc/resolv.conf"

      if [ "$PRIVATE_NETWORK" = 1 ]; then
        extraFlags+=" --network-veth"
        if [ -n "$HOST_BRIDGE" ]; then
          extraFlags+=" --network-bridge=$HOST_BRIDGE"
        fi
      fi

      ${if cfg . "extraVeths" or null != null then
        ''extraFlags+=" ${concatStringsSep " " (mapAttrsToList nspawnExtraVethArgs cfg . "extraVeths" or {})}"''
        else
          ''# No extra veth pairs to create''
      }

      for iface in $INTERFACES; do
        extraFlags+=" --network-interface=$iface"
      done

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

      # Run systemd-nspawn without startup notification (we'll
      # wait for the container systemd to signal readiness).
      EXIT_ON_REBOOT=1 \
      exec ${config.systemd.package}/bin/systemd-nspawn \
        --keep-unit \
        -M "$INSTANCE" -D "$root" $extraFlags \
        $EXTRA_NSPAWN_FLAGS \
        --notify-ready=yes \
        --bind-ro=/nix/store \
        --bind-ro=/nix/var/nix/db \
        --bind-ro=/nix/var/nix/daemon-socket \
        --bind="/nix/var/nix/profiles/per-container/$INSTANCE:/nix/var/nix/profiles" \
        --bind="/nix/var/nix/gcroots/per-container/$INSTANCE:/nix/var/nix/gcroots" \
        --setenv PRIVATE_NETWORK="$PRIVATE_NETWORK" \
        --setenv HOST_BRIDGE="$HOST_BRIDGE" \
        --setenv HOST_ADDRESS="$HOST_ADDRESS" \
        --setenv LOCAL_ADDRESS="$LOCAL_ADDRESS" \
        --setenv HOST_ADDRESS6="$HOST_ADDRESS6" \
        --setenv LOCAL_ADDRESS6="$LOCAL_ADDRESS6" \
        --setenv PATH="$PATH" \
        ${containerInit cfg} "''${SYSTEM_PATH:-/nix/var/nix/profiles/system}/init"
    ''
    );

  preStartScript = (cfg:
    ''
      # Clean up existing machined registration and interfaces.
      machinectl terminate "$INSTANCE" 2> /dev/null || true

      if [ "$PRIVATE_NETWORK" = 1 ]; then
        ip link del dev "ve-$INSTANCE" 2> /dev/null || true
        ip link del dev "vb-$INSTANCE" 2> /dev/null || true
      fi

      ${concatStringsSep "\n" (
        mapAttrsToList (name: cfg:
          ''ip link del dev ${name} 2> /dev/null || true ''
        ) cfg . "extraVeths" or {}
      )}
   ''
    );
  postStartScript = (cfg:
    let
      ipcall = (cfg: ipcmd: variable: attribute:
        if cfg . attribute or null == null then
          ''
            if [ -n "${variable}" ]; then
              ${ipcmd} add ${variable} dev $ifaceHost
            fi
          ''
        else
          ''${ipcmd} add ${cfg . attribute} dev $ifaceHost''
        );
      renderExtraVeth = (name: cfg:
        if cfg . "hostBridge" or null != null then
          ''
            # Add ${name} to bridge ${cfg.hostBridge}
            ip link set dev ${name} master ${cfg.hostBridge} up
          ''
        else
          ''
          # Set IPs and routes for ${name}
          ${optionalString (cfg . "hostAddress" or null != null) ''
            ip addr add ${cfg . "hostAddress"} dev ${name}
          ''}
          ${optionalString (cfg . "hostAddress6" or null != null) ''
            ip -6 addr add ${cfg . "hostAddress6"} dev ${name}
          ''}
          ${optionalString (cfg . "localAddress" or null != null) ''
            ip route add ${cfg . "localAddress"} dev ${name}
          ''}
          ${optionalString (cfg . "localAddress6" or null != null) ''
            ip -6 route add ${cfg . "localAddress6"} dev ${name}
          ''}
          ''
        );
    in
      ''
        if [ "$PRIVATE_NETWORK" = 1 ]; then
          if [ -z "$HOST_BRIDGE" ]; then
            ifaceHost=ve-$INSTANCE
            ip link set dev $ifaceHost up

            ${ipcall cfg "ip addr" "$HOST_ADDRESS" "hostAddress"}
            ${ipcall cfg "ip -6 addr" "$HOST_ADDRESS6" "hostAddress6"}
            ${ipcall cfg "ip route" "$LOCAL_ADDRESS" "localAddress"}
            ${ipcall cfg "ip -6 route" "$LOCAL_ADDRESS6" "localAddress6"}
          fi
          ${concatStringsSep "\n" (mapAttrsToList renderExtraVeth cfg . "extraVeths" or {})}
        fi

        # Get the leader PID so that we can signal it in
        # preStop. We can't use machinectl there because D-Bus
        # might be shutting down. FIXME: in systemd 219 we can
        # just signal systemd-nspawn to do a clean shutdown.
        machinectl show "$INSTANCE" | sed 's/Leader=\(.*\)/\1/;t;d' > "/run/containers/$INSTANCE.pid"
      ''
  );

  system = config.nixpkgs.system;

  bindMountOpts = { name, config, ... }: {

    options = {
      mountPoint = mkOption {
        example = "/mnt/usb";
        type = types.str;
        description = "Mount point on the container file system.";
      };
      hostPath = mkOption {
        default = null;
        example = "/home/alice";
        type = types.nullOr types.str;
        description = "Location of the host path to be mounted.";
      };
      isReadOnly = mkOption {
        default = true;
        example = true;
        type = types.bool;
        description = "Determine whether the mounted path will be accessed in read-only mode.";
      };
    };

    config = {
      mountPoint = mkDefault name;
    };

  };

  mkBindFlag = d:
               let flagPrefix = if d.isReadOnly then " --bind-ro=" else " --bind=";
                   mountstr = if d.hostPath != null then "${d.hostPath}:${d.mountPoint}" else "${d.mountPoint}";
               in flagPrefix + mountstr ;

  mkBindFlags = bs: concatMapStrings mkBindFlag (lib.attrValues bs);

  networkOptions = {
    hostBridge = mkOption {
      type = types.nullOr types.string;
      default = null;
      example = "br0";
      description = ''
        Put the host-side of the veth-pair into the named bridge.
        Only one of hostAddress* or hostBridge can be given.
      '';
    };

    hostAddress = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "10.231.136.1";
      description = ''
        The IPv4 address assigned to the host interface.
        (Not used when hostBridge is set.)
      '';
    };

    hostAddress6 = mkOption {
      type = types.nullOr types.string;
      default = null;
      example = "fc00::1";
      description = ''
        The IPv6 address assigned to the host interface.
        (Not used when hostBridge is set.)
      '';
    };

    localAddress = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "10.231.136.2";
      description = ''
        The IPv4 address assigned to the interface in the container.
        If a hostBridge is used, this should be given with netmask to access
        the whole network. Otherwise the default netmask is /32 and routing is
        set up from localAddress to hostAddress and back.
      '';
    };

    localAddress6 = mkOption {
      type = types.nullOr types.string;
      default = null;
      example = "fc00::2";
      description = ''
        The IPv6 address assigned to the interface in the container.
        If a hostBridge is used, this should be given with netmask to access
        the whole network. Otherwise the default netmask is /128 and routing is
        set up from localAddress6 to hostAddress6 and back.
      '';
    };

  };

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

    boot.enableContainers = mkOption {
      type = types.bool;
      default = !config.boot.isContainer;
      description = ''
        Whether to enable support for nixos containers.
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
              type = lib.mkOptionType {
                name = "Toplevel NixOS config";
                merge = loc: defs: (import ../../lib/eval-config.nix {
                  inherit system;
                  modules =
                    let extraConfig =
                      { boot.isContainer = true;
                        networking.hostName = mkDefault name;
                        networking.useDHCP = false;
                      };
                    in [ extraConfig ] ++ (map (x: x.value) defs);
                  prefix = [ "containers" name ];
                }).config;
              };
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

            interfaces = mkOption {
              type = types.listOf types.string;
              default = [];
              example = [ "eth1" "eth2" ];
              description = ''
                The list of interfaces to be moved into the container.
              '';
            };

            extraVeths = mkOption {
              type = types.attrsOf types.optionSet;
              default = {};
              options = networkOptions;
              description = ''
                Extra veth-pairs to be created for the container
              '';
            };

            autoStart = mkOption {
              type = types.bool;
              default = false;
              description = ''
                Wether the container is automatically started at boot-time.
              '';
            };

            bindMounts = mkOption {
              type = types.loaOf types.optionSet;
              options = [ bindMountOpts ];
              default = {};
              example = { "/home" = { hostPath = "/home/alice";
                                      isReadOnly = false; };
                        };

              description =
                ''
                  An extra list of directories that is bound to the container.
                '';
            };

          } // networkOptions;

          config = mkMerge
            [
              (mkIf options.config.isDefined {
                path = config.config.system.build.toplevel;
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


  config = mkIf (config.boot.enableContainers) (let

    unit = {
      description = "Container '%i'";

      unitConfig.RequiresMountsFor = [ "/var/lib/containers/%i" ];

      path = [ pkgs.iproute ];

      environment.INSTANCE = "%i";
      environment.root = "/var/lib/containers/%i";

      preStart = preStartScript {};

      script = startScript {};

      postStart = postStartScript {};

      preStop =
        ''
          pid="$(cat /run/containers/$INSTANCE.pid)"
          if [ -n "$pid" ]; then
            kill -RTMIN+4 "$pid"
          fi
          rm -f "/run/containers/$INSTANCE.pid"
        '';

      restartIfChanged = false;

      serviceConfig = {
        ExecReload = pkgs.writeScript "reload-container"
          ''
            #! ${pkgs.stdenv.shell} -e
            ${pkgs.nixos-container}/bin/nixos-container run "$INSTANCE" -- \
              bash --login -c "''${SYSTEM_PATH:-/nix/var/nix/profiles/system}/bin/switch-to-configuration test"
          '';

        SyslogIdentifier = "container %i";

        EnvironmentFile = "-/etc/containers/%i.conf";

        Type = "notify";

        # Note that on reboot, systemd-nspawn returns 133, so this
        # unit will be restarted. On poweroff, it returns 0, so the
        # unit won't be restarted.
        RestartForceExitStatus = "133";
        SuccessExitStatus = "133";

        Restart = "on-failure";

        # Hack: we don't want to kill systemd-nspawn, since we call
        # "machinectl poweroff" in preStop to shut down the
        # container cleanly. But systemd requires sending a signal
        # (at least if we want remaining processes to be killed
        # after the timeout). So send an ignored signal.
        KillMode = "mixed";
        KillSignal = "WINCH";

        DevicePolicy = "closed";
      };
    };
  in {
    systemd.services = listToAttrs (filter (x: x.value != null) (
      # The generic container template used by imperative containers
      [{ name = "container@"; value = unit; }]
      # declarative containers
      ++ (mapAttrsToList (name: cfg: nameValuePair "container@${name}" (
        unit // {
          preStart = preStartScript cfg;
          script = startScript cfg;
          postStart = postStartScript cfg;
        } // (
        if cfg.autoStart then
          {
            wantedBy = [ "multi-user.target" ];
            wants = [ "network.target" ];
            after = [ "network.target" ];
            restartTriggers = [ cfg.path ];
            reloadIfChanged = true;
          }
        else {})
      )) config.containers)
    ));

    # Generate a configuration file in /etc/containers for each
    # container so that container@.target can get the container
    # configuration.
    environment.etc = mapAttrs' (name: cfg: nameValuePair "containers/${name}.conf"
      { text =
          ''
            SYSTEM_PATH=${cfg.path}
            ${optionalString cfg.privateNetwork ''
              PRIVATE_NETWORK=1
              ${optionalString (cfg.hostBridge != null) ''
                HOST_BRIDGE=${cfg.hostBridge}
              ''}
              ${optionalString (cfg.hostAddress != null) ''
                HOST_ADDRESS=${cfg.hostAddress}
              ''}
              ${optionalString (cfg.hostAddress6 != null) ''
                HOST_ADDRESS6=${cfg.hostAddress6}
              ''}
              ${optionalString (cfg.localAddress != null) ''
                LOCAL_ADDRESS=${cfg.localAddress}
              ''}
              ${optionalString (cfg.localAddress6 != null) ''
                LOCAL_ADDRESS6=${cfg.localAddress6}
              ''}
            ''}
            INTERFACES="${toString cfg.interfaces}"
            ${optionalString cfg.autoStart ''
              AUTO_START=1
            ''}
            EXTRA_NSPAWN_FLAGS="${mkBindFlags cfg.bindMounts}"
          '';
      }) config.containers;

    # Generate /etc/hosts entries for the containers.
    networking.extraHosts = concatStrings (mapAttrsToList (name: cfg: optionalString (cfg.localAddress != null)
      ''
        ${cfg.localAddress} ${name}.containers
      '') config.containers);

    networking.dhcpcd.denyInterfaces = [ "ve-*" ];

    environment.systemPackages = [ pkgs.nixos-container ];
  });
}
