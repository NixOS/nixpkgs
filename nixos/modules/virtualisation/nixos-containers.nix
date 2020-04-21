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
        ${optionalString (cfg.localAddress != null) ''
          echo "Setting ip for ${name}"
          ip addr add ${cfg.localAddress} dev ${name}
        ''}
        ${optionalString (cfg.localAddress6 != null) ''
          echo "Setting ip6 for ${name}"
          ip -6 addr add ${cfg.localAddress6} dev ${name}
        ''}
        ${optionalString (cfg.hostAddress != null) ''
          echo "Setting route to host for ${name}"
          ip route add ${cfg.hostAddress} dev ${name}
        ''}
        ${optionalString (cfg.hostAddress6 != null) ''
          echo "Setting route6 to host for ${name}"
          ip -6 route add ${cfg.hostAddress6} dev ${name}
        ''}
        ''
        );
    in
      pkgs.writeScript "container-init"
      ''
        #! ${pkgs.runtimeShell} -e

        # Initialise the container side of the veth pair.
        if [ -n "$HOST_ADDRESS" ]   || [ -n "$HOST_ADDRESS6" ]  ||
           [ -n "$LOCAL_ADDRESS" ]  || [ -n "$LOCAL_ADDRESS6" ] ||
           [ -n "$HOST_BRIDGE" ]; then
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

          ${concatStringsSep "\n" (mapAttrsToList renderExtraVeth cfg.extraVeths)}
        fi

        # Start the regular stage 1 script.
        exec "$1"
      ''
    );

  nspawnExtraVethArgs = (name: cfg: "--network-veth-extra=${name}");

  startScript = cfg:
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
        extraFlags+=" --private-network"
      fi

      if [ -n "$HOST_ADDRESS" ]  || [ -n "$LOCAL_ADDRESS" ] ||
         [ -n "$HOST_ADDRESS6" ] || [ -n "$LOCAL_ADDRESS6" ]; then
        extraFlags+=" --network-veth"
      fi

      if [ -n "$HOST_PORT" ]; then
        OIFS=$IFS
        IFS=","
        for i in $HOST_PORT
        do
            extraFlags+=" --port=$i"
        done
        IFS=$OIFS
      fi

      if [ -n "$HOST_BRIDGE" ]; then
        extraFlags+=" --network-bridge=$HOST_BRIDGE"
      fi

      extraFlags+=" ${concatStringsSep " " (mapAttrsToList nspawnExtraVethArgs cfg.extraVeths)}"

      for iface in $INTERFACES; do
        extraFlags+=" --network-interface=$iface"
      done

      for iface in $MACVLANS; do
        extraFlags+=" --network-macvlan=$iface"
      done

      # If the host is 64-bit and the container is 32-bit, add a
      # --personality flag.
      ${optionalString (config.nixpkgs.localSystem.system == "x86_64-linux") ''
        if [ "$(< ''${SYSTEM_PATH:-/nix/var/nix/profiles/per-container/$INSTANCE/system}/system)" = i686-linux ]; then
          extraFlags+=" --personality=x86"
        fi
      ''}

      # Run systemd-nspawn without startup notification (we'll
      # wait for the container systemd to signal readiness).
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
        ${optionalString (!cfg.ephemeral) "--link-journal=try-guest"} \
        --setenv PRIVATE_NETWORK="$PRIVATE_NETWORK" \
        --setenv HOST_BRIDGE="$HOST_BRIDGE" \
        --setenv HOST_ADDRESS="$HOST_ADDRESS" \
        --setenv LOCAL_ADDRESS="$LOCAL_ADDRESS" \
        --setenv HOST_ADDRESS6="$HOST_ADDRESS6" \
        --setenv LOCAL_ADDRESS6="$LOCAL_ADDRESS6" \
        --setenv HOST_PORT="$HOST_PORT" \
        --setenv PATH="$PATH" \
        ${optionalString cfg.ephemeral "--ephemeral"} \
        ${if cfg.additionalCapabilities != null && cfg.additionalCapabilities != [] then
          ''--capability="${concatStringsSep "," cfg.additionalCapabilities}"'' else ""
        } \
        ${if cfg.tmpfs != null && cfg.tmpfs != [] then
          ''--tmpfs=${concatStringsSep " --tmpfs=" cfg.tmpfs}'' else ""
        } \
        ${containerInit cfg} "''${SYSTEM_PATH:-/nix/var/nix/profiles/system}/init"
    '';

  preStartScript = cfg:
    ''
      # Clean up existing machined registration and interfaces.
      machinectl terminate "$INSTANCE" 2> /dev/null || true

      if [ -n "$HOST_ADDRESS" ]  || [ -n "$LOCAL_ADDRESS" ] ||
         [ -n "$HOST_ADDRESS6" ] || [ -n "$LOCAL_ADDRESS6" ]; then
        ip link del dev "ve-$INSTANCE" 2> /dev/null || true
        ip link del dev "vb-$INSTANCE" 2> /dev/null || true
      fi

      ${concatStringsSep "\n" (
        mapAttrsToList (name: cfg:
          ''ip link del dev ${name} 2> /dev/null || true ''
        ) cfg.extraVeths
      )}
   '';

  postStartScript = (cfg:
    let
      ipcall = cfg: ipcmd: variable: attribute:
        if cfg.${attribute} == null then
          ''
            if [ -n "${variable}" ]; then
              ${ipcmd} add ${variable} dev $ifaceHost
            fi
          ''
        else
          ''${ipcmd} add ${cfg.${attribute}} dev $ifaceHost'';
      renderExtraVeth = name: cfg:
        if cfg.hostBridge != null then
          ''
            # Add ${name} to bridge ${cfg.hostBridge}
            ip link set dev ${name} master ${cfg.hostBridge} up
          ''
        else
          ''
            echo "Bring ${name} up"
            ip link set dev ${name} up
            # Set IPs and routes for ${name}
            ${optionalString (cfg.hostAddress != null) ''
              ip addr add ${cfg.hostAddress} dev ${name}
            ''}
            ${optionalString (cfg.hostAddress6 != null) ''
              ip -6 addr add ${cfg.hostAddress6} dev ${name}
            ''}
            ${optionalString (cfg.localAddress != null) ''
              ip route add ${cfg.localAddress} dev ${name}
            ''}
            ${optionalString (cfg.localAddress6 != null) ''
              ip -6 route add ${cfg.localAddress6} dev ${name}
            ''}
          '';
    in
      ''
        if [ -n "$HOST_ADDRESS" ]  || [ -n "$LOCAL_ADDRESS" ] ||
           [ -n "$HOST_ADDRESS6" ] || [ -n "$LOCAL_ADDRESS6" ]; then
          if [ -z "$HOST_BRIDGE" ]; then
            ifaceHost=ve-$INSTANCE
            ip link set dev $ifaceHost up

            ${ipcall cfg "ip addr" "$HOST_ADDRESS" "hostAddress"}
            ${ipcall cfg "ip -6 addr" "$HOST_ADDRESS6" "hostAddress6"}
            ${ipcall cfg "ip route" "$LOCAL_ADDRESS" "localAddress"}
            ${ipcall cfg "ip -6 route" "$LOCAL_ADDRESS6" "localAddress6"}
          fi
          ${concatStringsSep "\n" (mapAttrsToList renderExtraVeth cfg.extraVeths)}
        fi
      ''
  );

  serviceDirectives = cfg: {
    ExecReload = pkgs.writeScript "reload-container"
      ''
        #! ${pkgs.runtimeShell} -e
        ${pkgs.nixos-container}/bin/nixos-container run "$INSTANCE" -- \
          bash --login -c "''${SYSTEM_PATH:-/nix/var/nix/profiles/system}/bin/switch-to-configuration test"
      '';

    SyslogIdentifier = "container %i";

    EnvironmentFile = "-/etc/containers/%i.conf";

    Type = "notify";

    RuntimeDirectory = lib.optional cfg.ephemeral "containers/%i";

    # Note that on reboot, systemd-nspawn returns 133, so this
    # unit will be restarted. On poweroff, it returns 0, so the
    # unit won't be restarted.
    RestartForceExitStatus = "133";
    SuccessExitStatus = "133";

    # Some containers take long to start
    # especially when you automatically start many at once
    TimeoutStartSec = cfg.timeoutStartSec;

    Restart = "on-failure";

    Slice = "machine.slice";
    Delegate = true;

    # Hack: we don't want to kill systemd-nspawn, since we call
    # "machinectl poweroff" in preStop to shut down the
    # container cleanly. But systemd requires sending a signal
    # (at least if we want remaining processes to be killed
    # after the timeout). So send an ignored signal.
    KillMode = "mixed";
    KillSignal = "WINCH";

    DevicePolicy = "closed";
    DeviceAllow = map (d: "${d.node} ${d.modifier}") cfg.allowedDevices;
  };


  system = config.nixpkgs.localSystem.system;

  bindMountOpts = { name, ... }: {

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
        type = types.bool;
        description = "Determine whether the mounted path will be accessed in read-only mode.";
      };
    };

    config = {
      mountPoint = mkDefault name;
    };

  };

  allowedDeviceOpts = { ... }: {
    options = {
      node = mkOption {
        example = "/dev/net/tun";
        type = types.str;
        description = "Path to device node";
      };
      modifier = mkOption {
        example = "rw";
        type = types.str;
        description = ''
          Device node access modifier. Takes a combination
          <literal>r</literal> (read), <literal>w</literal> (write), and
          <literal>m</literal> (mknod). See the
          <literal>systemd.resource-control(5)</literal> man page for more
          information.'';
      };
    };
  };


  mkBindFlag = d:
               let flagPrefix = if d.isReadOnly then " --bind-ro=" else " --bind=";
                   mountstr = if d.hostPath != null then "${d.hostPath}:${d.mountPoint}" else "${d.mountPoint}";
               in flagPrefix + mountstr ;

  mkBindFlags = bs: concatMapStrings mkBindFlag (lib.attrValues bs);

  networkOptions = {
    hostBridge = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "br0";
      description = ''
        Put the host-side of the veth-pair into the named bridge.
        Only one of hostAddress* or hostBridge can be given.
      '';
    };

    forwardPorts = mkOption {
      type = types.listOf (types.submodule {
        options = {
          protocol = mkOption {
            type = types.str;
            default = "tcp";
            description = "The protocol specifier for port forwarding between host and container";
          };
          hostPort = mkOption {
            type = types.int;
            description = "Source port of the external interface on host";
          };
          containerPort = mkOption {
            type = types.nullOr types.int;
            default = null;
            description = "Target port of container";
          };
        };
      });
      default = [];
      example = [ { protocol = "tcp"; hostPort = 8080; containerPort = 80; } ];
      description = ''
        List of forwarded ports from host to container. Each forwarded port
        is specified by protocol, hostPort and containerPort. By default,
        protocol is tcp and hostPort and containerPort are assumed to be
        the same if containerPort is not explicitly given.
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
      type = types.nullOr types.str;
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
      type = types.nullOr types.str;
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

  dummyConfig =
    {
      extraVeths = {};
      additionalCapabilities = [];
      ephemeral = false;
      timeoutStartSec = "15s";
      allowedDevices = [];
      hostAddress = null;
      hostAddress6 = null;
      localAddress = null;
      localAddress6 = null;
      tmpfs = null;
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
        Whether to enable support for NixOS containers.
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
              type = let
                confPkgs = if config.pkgs == null then pkgs else config.pkgs;
              in lib.mkOptionType {
                name = "Toplevel NixOS config";
                merge = loc: defs: (import (confPkgs.path + "/nixos/lib/eval-config.nix") {
                  inherit system;
                  pkgs = confPkgs;
                  baseModules = import (confPkgs.path + "/nixos/modules/module-list.nix");
                  inherit (confPkgs) lib;
                  modules =
                    let
                      extraConfig = {
                        _file = "module at ${__curPos.file}:${toString __curPos.line}";
                        config = {
                          boot.isContainer = true;
                          networking.hostName = mkDefault name;
                          networking.useDHCP = false;
                          assertions = [
                            {
                              assertion =  config.privateNetwork -> stringLength name < 12;
                              message = ''
                                Container name `${name}` is too long: When `privateNetwork` is enabled, container names can
                                not be longer than 11 characters, because the container's interface name is derived from it.
                                This might be fixed in the future. See https://github.com/NixOS/nixpkgs/issues/38509
                              '';
                            }
                          ];
                        };
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

            additionalCapabilities = mkOption {
              type = types.listOf types.str;
              default = [];
              example = [ "CAP_NET_ADMIN" "CAP_MKNOD" ];
              description = ''
                Grant additional capabilities to the container.  See the
                capabilities(7) and systemd-nspawn(1) man pages for more
                information.
              '';
            };

            pkgs = mkOption {
              type = types.nullOr types.attrs;
              default = null;
              example = literalExample "pkgs";
              description = ''
                Customise which nixpkgs to use for this container.
              '';
            };

            ephemeral = mkOption {
              type = types.bool;
              default = false;
              description = ''
                Runs container in ephemeral mode with the empty root filesystem at boot.
                This way container will be bootstrapped from scratch on each boot
                and will be cleaned up on shutdown leaving no traces behind.
                Useful for completely stateless, reproducible containers.

                Note that this option might require to do some adjustments to the container configuration,
                e.g. you might want to set
                <varname>systemd.network.networks.$interface.dhcpConfig.ClientIdentifier</varname> to "mac"
                if you use <varname>macvlans</varname> option.
                This way dhcp client identifier will be stable between the container restarts.

                Note that the container journal will not be linked to the host if this option is enabled.
              '';
            };

            enableTun = mkOption {
              type = types.bool;
              default = false;
              description = ''
                Allows the container to create and setup tunnel interfaces
                by granting the <literal>NET_ADMIN</literal> capability and
                enabling access to <literal>/dev/net/tun</literal>.
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
              type = types.listOf types.str;
              default = [];
              example = [ "eth1" "eth2" ];
              description = ''
                The list of interfaces to be moved into the container.
              '';
            };

            macvlans = mkOption {
              type = types.listOf types.str;
              default = [];
              example = [ "eth1" "eth2" ];
              description = ''
                The list of host interfaces from which macvlans will be
                created. For each interface specified, a macvlan interface
                will be created and moved to the container.
              '';
            };

            extraVeths = mkOption {
              type = with types; attrsOf (submodule { options = networkOptions; });
              default = {};
              description = ''
                Extra veth-pairs to be created for the container
              '';
            };

            autoStart = mkOption {
              type = types.bool;
              default = false;
              description = ''
                Whether the container is automatically started at boot-time.
              '';
            };

		    timeoutStartSec = mkOption {
		      type = types.str;
		      default = "1min";
		      description = ''
		        Time for the container to start. In case of a timeout,
		        the container processes get killed.
		        See <citerefentry><refentrytitle>systemd.time</refentrytitle>
		        <manvolnum>7</manvolnum></citerefentry>
		        for more information about the format.
		       '';
		    };

            bindMounts = mkOption {
              type = with types; loaOf (submodule bindMountOpts);
              default = {};
              example = literalExample ''
                { "/home" = { hostPath = "/home/alice";
                              isReadOnly = false; };
                }
              '';

              description =
                ''
                  An extra list of directories that is bound to the container.
                '';
            };

            allowedDevices = mkOption {
              type = with types; listOf (submodule allowedDeviceOpts);
              default = [];
              example = [ { node = "/dev/net/tun"; modifier = "rw"; } ];
              description = ''
                A list of device nodes to which the containers has access to.
              '';
            };

            tmpfs = mkOption {
              type = types.listOf types.str;
              default = [];
              example = [ "/var" ];
              description = ''
                Mounts a set of tmpfs file systems into the container.
                Multiple paths can be specified.
                Valid items must conform to the --tmpfs argument
                of systemd-nspawn. See systemd-nspawn(1) for details.
              '';
            };

            extraFlags = mkOption {
              type = types.listOf types.str;
              default = [];
              example = [ "--drop-capability=CAP_SYS_CHROOT" ];
              description = ''
                Extra flags passed to the systemd-nspawn command.
                See systemd-nspawn(1) for details.
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
                    services.postgresql.package = pkgs.postgresql_9_6;

                    system.stateVersion = "17.03";
                  };
              };
          }
        '';
      description = ''
        A set of NixOS system configurations to be run as lightweight
        containers.  Each container appears as a service
        <literal>container-<replaceable>name</replaceable></literal>
        on the host system, allowing it to be started and stopped via
        <command>systemctl</command>.
      '';
    };

  };


  config = mkIf (config.boot.enableContainers) (let

    unit = {
      description = "Container '%i'";

      unitConfig.RequiresMountsFor = "/var/lib/containers/%i";

      path = [ pkgs.iproute ];

      environment = {
        root = "/var/lib/containers/%i";
        INSTANCE = "%i";
      };

      preStart = preStartScript dummyConfig;

      script = startScript dummyConfig;

      postStart = postStartScript dummyConfig;

      preStop = "machinectl poweroff $INSTANCE";

      restartIfChanged = false;

      serviceConfig = serviceDirectives dummyConfig;
    };
  in {
    systemd.targets.multi-user.wants = [ "machines.target" ];

    systemd.services = listToAttrs (filter (x: x.value != null) (
      # The generic container template used by imperative containers
      [{ name = "container@"; value = unit; }]
      # declarative containers
      ++ (mapAttrsToList (name: cfg: nameValuePair "container@${name}" (let
          containerConfig = cfg // (
          if cfg.enableTun then
            {
              allowedDevices = cfg.allowedDevices
                ++ [ { node = "/dev/net/tun"; modifier = "rw"; } ];
              additionalCapabilities = cfg.additionalCapabilities
                ++ [ "CAP_NET_ADMIN" ];
            }
          else {});
        in
          recursiveUpdate unit {
            preStart = preStartScript containerConfig;
            script = startScript containerConfig;
            postStart = postStartScript containerConfig;
            serviceConfig = serviceDirectives containerConfig;
            unitConfig.RequiresMountsFor = lib.optional (!containerConfig.ephemeral) "/var/lib/containers/%i";
            environment.root = if containerConfig.ephemeral then "/run/containers/%i" else "/var/lib/containers/%i";
          } // (
          if containerConfig.autoStart then
            {
              wantedBy = [ "machines.target" ];
              wants = [ "network.target" ];
              after = [ "network.target" ];
              restartTriggers = [
                containerConfig.path
                config.environment.etc."containers/${name}.conf".source
              ];
              restartIfChanged = true;
            }
          else {})
      )) config.containers)
    ));

    # Generate a configuration file in /etc/containers for each
    # container so that container@.target can get the container
    # configuration.
    environment.etc =
      let mkPortStr = p: p.protocol + ":" + (toString p.hostPort) + ":" + (if p.containerPort == null then toString p.hostPort else toString p.containerPort);
      in mapAttrs' (name: cfg: nameValuePair "containers/${name}.conf"
      { text =
          ''
            SYSTEM_PATH=${cfg.path}
            ${optionalString cfg.privateNetwork ''
              PRIVATE_NETWORK=1
              ${optionalString (cfg.hostBridge != null) ''
                HOST_BRIDGE=${cfg.hostBridge}
              ''}
              ${optionalString (length cfg.forwardPorts > 0) ''
                HOST_PORT=${concatStringsSep "," (map mkPortStr cfg.forwardPorts)}
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
            MACVLANS="${toString cfg.macvlans}"
            ${optionalString cfg.autoStart ''
              AUTO_START=1
            ''}
            EXTRA_NSPAWN_FLAGS="${mkBindFlags cfg.bindMounts +
              optionalString (cfg.extraFlags != [])
                (" " + concatStringsSep " " cfg.extraFlags)}"
          '';
      }) config.containers;

    # Generate /etc/hosts entries for the containers.
    networking.extraHosts = concatStrings (mapAttrsToList (name: cfg: optionalString (cfg.localAddress != null)
      ''
        ${head (splitString "/" cfg.localAddress)} ${name}.containers
      '') config.containers);

    networking.dhcpcd.denyInterfaces = [ "ve-*" "vb-*" ];

    services.udev.extraRules = optionalString config.networking.networkmanager.enable ''
      # Don't manage interfaces created by nixos-container.
      ENV{INTERFACE}=="v[eb]-*", ENV{NM_UNMANAGED}="1"
    '';

    environment.systemPackages = [ pkgs.nixos-container ];

    boot.kernelModules = [
      "bridge"
      "macvlan"
      "tap"
      "tun"
    ];
  });
}
