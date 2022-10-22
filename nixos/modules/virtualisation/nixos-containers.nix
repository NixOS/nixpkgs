{ config, lib, pkgs, ... }:

with lib;

let

  configurationPrefix = optionalString (versionAtLeast config.system.stateVersion "22.05") "nixos-";
  configurationDirectoryName = "${configurationPrefix}containers";
  configurationDirectory = "/etc/${configurationDirectoryName}";
  stateDirectory = "/var/lib/${configurationPrefix}containers";

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

        # Exit early if we're asked to shut down.
        trap "exit 0" SIGRTMIN+3

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
        fi

        ${concatStringsSep "\n" (mapAttrsToList renderExtraVeth cfg.extraVeths)}

        # Start the regular stage 2 script.
        # We source instead of exec to not lose an early stop signal, which is
        # also the only _reliable_ shutdown signal we have since early stop
        # does not execute ExecStop* commands.
        set +e
        . "$1"
      ''
    );

  nspawnExtraVethArgs = (name: cfg: "--network-veth-extra=${name}");

  startScript = cfg:
    ''
      mkdir -p -m 0755 "$root/etc" "$root/var/lib"
      mkdir -p -m 0700 "$root/var/lib/private" "$root/root" /run/nixos-containers
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
      ${optionalString (pkgs.stdenv.hostPlatform.system == "x86_64-linux") ''
        if [ "$(< ''${SYSTEM_PATH:-/nix/var/nix/profiles/per-container/$INSTANCE/system}/system)" = i686-linux ]; then
          extraFlags+=" --personality=x86"
        fi
      ''}

      # Run systemd-nspawn without startup notification (we'll
      # wait for the container systemd to signal readiness)
      # Kill signal handling means systemd-nspawn will pass a system-halt signal
      # to the container systemd when it receives SIGTERM for container shutdown;
      # containerInit and stage2 have to handle this as well.
      exec ${config.systemd.package}/bin/systemd-nspawn \
        --keep-unit \
        -M "$INSTANCE" -D "$root" $extraFlags \
        $EXTRA_NSPAWN_FLAGS \
        --notify-ready=yes \
        --kill-signal=SIGRTMIN+3 \
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
          "ip link del dev ${name} 2> /dev/null || true "
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
          "${ipcmd} add ${cfg.${attribute}} dev $ifaceHost";
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
        fi
        ${concatStringsSep "\n" (mapAttrsToList renderExtraVeth cfg.extraVeths)}
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

    EnvironmentFile = "-${configurationDirectory}/%i.conf";

    Type = "notify";

    RuntimeDirectory = lib.optional cfg.ephemeral "${configurationDirectoryName}/%i";

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

    # We rely on systemd-nspawn turning a SIGTERM to itself into a shutdown
    # signal (SIGRTMIN+3) for the inner container.
    KillMode = "mixed";
    KillSignal = "TERM";

    DevicePolicy = "closed";
    DeviceAllow = map (d: "${d.node} ${d.modifier}") cfg.allowedDevices;
  };

  inherit (config.nixpkgs) localSystem;
  kernelVersion = config.boot.kernelPackages.kernel.version;

  bindMountOpts = { name, ... }: {

    options = {
      mountPoint = mkOption {
        example = "/mnt/usb";
        type = types.str;
        description = lib.mdDoc "Mount point on the container file system.";
      };
      hostPath = mkOption {
        default = null;
        example = "/home/alice";
        type = types.nullOr types.str;
        description = lib.mdDoc "Location of the host path to be mounted.";
      };
      isReadOnly = mkOption {
        default = true;
        type = types.bool;
        description = lib.mdDoc "Determine whether the mounted path will be accessed in read-only mode.";
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
        description = lib.mdDoc "Path to device node";
      };
      modifier = mkOption {
        example = "rw";
        type = types.str;
        description = lib.mdDoc ''
          Device node access modifier. Takes a combination
          `r` (read), `w` (write), and
          `m` (mknod). See the
          `systemd.resource-control(5)` man page for more
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
      description = lib.mdDoc ''
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
            description = lib.mdDoc "The protocol specifier for port forwarding between host and container";
          };
          hostPort = mkOption {
            type = types.int;
            description = lib.mdDoc "Source port of the external interface on host";
          };
          containerPort = mkOption {
            type = types.nullOr types.int;
            default = null;
            description = lib.mdDoc "Target port of container";
          };
        };
      });
      default = [];
      example = [ { protocol = "tcp"; hostPort = 8080; containerPort = 80; } ];
      description = lib.mdDoc ''
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
      description = lib.mdDoc ''
        The IPv4 address assigned to the host interface.
        (Not used when hostBridge is set.)
      '';
    };

    hostAddress6 = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "fc00::1";
      description = lib.mdDoc ''
        The IPv6 address assigned to the host interface.
        (Not used when hostBridge is set.)
      '';
    };

    localAddress = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "10.231.136.2";
      description = lib.mdDoc ''
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
      description = lib.mdDoc ''
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
      timeoutStartSec = "1min";
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
      description = lib.mdDoc ''
        Whether this NixOS machine is a lightweight container running
        in another NixOS system.
      '';
    };

    boot.enableContainers = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Whether to enable support for NixOS containers. Defaults to true
        (at no cost if containers are not actually used).
      '';
    };

    containers = mkOption {
      type = types.attrsOf (types.submodule (
        { config, options, name, ... }:
        {
          options = {
            config = mkOption {
              description = lib.mdDoc ''
                A specification of the desired configuration of this
                container, as a NixOS module.
              '';
              type = lib.mkOptionType {
                name = "Toplevel NixOS config";
                merge = loc: defs: (import "${toString config.nixpkgs}/nixos/lib/eval-config.nix" {
                  modules =
                    let
                      extraConfig = {
                        _file = "module at ${__curPos.file}:${toString __curPos.line}";
                        config = {
                          nixpkgs = { inherit localSystem; };
                          boot.isContainer = true;
                          networking.hostName = mkDefault name;
                          networking.useDHCP = false;
                          assertions = [
                            {
                              assertion =
                                (builtins.compareVersions kernelVersion "5.8" <= 0)
                                -> config.privateNetwork
                                -> stringLength name <= 11;
                              message = ''
                                Container name `${name}` is too long: When `privateNetwork` is enabled, container names can
                                not be longer than 11 characters, because the container's interface name is derived from it.
                                You should either make the container name shorter or upgrade to a more recent kernel that
                                supports interface altnames (i.e. at least Linux 5.8 - please see https://github.com/NixOS/nixpkgs/issues/38509
                                for details).
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
              example = "/nix/var/nix/profiles/per-container/webserver";
              description = lib.mdDoc ''
                As an alternative to specifying
                {option}`config`, you can specify the path to
                the evaluated NixOS system configuration, typically a
                symlink to a system profile.
              '';
            };

            additionalCapabilities = mkOption {
              type = types.listOf types.str;
              default = [];
              example = [ "CAP_NET_ADMIN" "CAP_MKNOD" ];
              description = lib.mdDoc ''
                Grant additional capabilities to the container.  See the
                capabilities(7) and systemd-nspawn(1) man pages for more
                information.
              '';
            };

            nixpkgs = mkOption {
              type = types.path;
              default = pkgs.path;
              defaultText = literalExpression "pkgs.path";
              description = lib.mdDoc ''
                A path to the nixpkgs that provide the modules, pkgs and lib for evaluating the container.

                To only change the `pkgs` argument used inside the container modules,
                set the `nixpkgs.*` options in the container {option}`config`.
                Setting `config.nixpkgs.pkgs = pkgs` speeds up the container evaluation
                by reusing the system pkgs, but the `nixpkgs.config` option in the
                container config is ignored in this case.
              '';
            };

            ephemeral = mkOption {
              type = types.bool;
              default = false;
              description = lib.mdDoc ''
                Runs container in ephemeral mode with the empty root filesystem at boot.
                This way container will be bootstrapped from scratch on each boot
                and will be cleaned up on shutdown leaving no traces behind.
                Useful for completely stateless, reproducible containers.

                Note that this option might require to do some adjustments to the container configuration,
                e.g. you might want to set
                {var}`systemd.network.networks.$interface.dhcpV4Config.ClientIdentifier` to "mac"
                if you use {var}`macvlans` option.
                This way dhcp client identifier will be stable between the container restarts.

                Note that the container journal will not be linked to the host if this option is enabled.
              '';
            };

            enableTun = mkOption {
              type = types.bool;
              default = false;
              description = lib.mdDoc ''
                Allows the container to create and setup tunnel interfaces
                by granting the `NET_ADMIN` capability and
                enabling access to `/dev/net/tun`.
              '';
            };

            privateNetwork = mkOption {
              type = types.bool;
              default = false;
              description = lib.mdDoc ''
                Whether to give the container its own private virtual
                Ethernet interface.  The interface is called
                `eth0`, and is hooked up to the interface
                `ve-«container-name»`
                on the host.  If this option is not set, then the
                container shares the network interfaces of the host,
                and can bind to any port on any interface.
              '';
            };

            interfaces = mkOption {
              type = types.listOf types.str;
              default = [];
              example = [ "eth1" "eth2" ];
              description = lib.mdDoc ''
                The list of interfaces to be moved into the container.
              '';
            };

            macvlans = mkOption {
              type = types.listOf types.str;
              default = [];
              example = [ "eth1" "eth2" ];
              description = lib.mdDoc ''
                The list of host interfaces from which macvlans will be
                created. For each interface specified, a macvlan interface
                will be created and moved to the container.
              '';
            };

            extraVeths = mkOption {
              type = with types; attrsOf (submodule { options = networkOptions; });
              default = {};
              description = lib.mdDoc ''
                Extra veth-pairs to be created for the container.
              '';
            };

            autoStart = mkOption {
              type = types.bool;
              default = false;
              description = lib.mdDoc ''
                Whether the container is automatically started at boot-time.
              '';
            };

            timeoutStartSec = mkOption {
              type = types.str;
              default = "1min";
              description = lib.mdDoc ''
                Time for the container to start. In case of a timeout,
                the container processes get killed.
                See {manpage}`systemd.time(7)`
                for more information about the format.
               '';
            };

            bindMounts = mkOption {
              type = with types; attrsOf (submodule bindMountOpts);
              default = {};
              example = literalExpression ''
                { "/home" = { hostPath = "/home/alice";
                              isReadOnly = false; };
                }
              '';

              description =
                lib.mdDoc ''
                  An extra list of directories that is bound to the container.
                '';
            };

            allowedDevices = mkOption {
              type = with types; listOf (submodule allowedDeviceOpts);
              default = [];
              example = [ { node = "/dev/net/tun"; modifier = "rw"; } ];
              description = lib.mdDoc ''
                A list of device nodes to which the containers has access to.
              '';
            };

            tmpfs = mkOption {
              type = types.listOf types.str;
              default = [];
              example = [ "/var" ];
              description = lib.mdDoc ''
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
              description = lib.mdDoc ''
                Extra flags passed to the systemd-nspawn command.
                See systemd-nspawn(1) for details.
              '';
            };

            # Removed option. See `checkAssertion` below for the accompanying error message.
            pkgs = mkOption { visible = false; };
          } // networkOptions;

          config = let
            # Throw an error when removed option `pkgs` is used.
            # Because this is a submodule we cannot use `mkRemovedOptionModule` or option `assertions`.
            optionPath = "containers.${name}.pkgs";
            files = showFiles options.pkgs.files;
            checkAssertion = if options.pkgs.isDefined then throw ''
              The option definition `${optionPath}' in ${files} no longer has any effect; please remove it.

              Alternatively, you can use the following options:
              - containers.${name}.nixpkgs
                This sets the nixpkgs (and thereby the modules, pkgs and lib) that
                are used for evaluating the container.

              - containers.${name}.config.nixpkgs.pkgs
                This only sets the `pkgs` argument used inside the container modules.
            ''
            else null;
          in {
            path = builtins.seq checkAssertion
              mkIf options.config.isDefined config.config.system.build.toplevel;
          };
        }));

      default = {};
      example = literalExpression
        ''
          { webserver =
              { path = "/nix/var/nix/profiles/webserver";
              };
            database =
              { config =
                  { config, pkgs, ... }:
                  { services.postgresql.enable = true;
                    services.postgresql.package = pkgs.postgresql_10;

                    system.stateVersion = "21.05";
                  };
              };
          }
        '';
      description = lib.mdDoc ''
        A set of NixOS system configurations to be run as lightweight
        containers.  Each container appears as a service
        `container-«name»`
        on the host system, allowing it to be started and stopped via
        {command}`systemctl`.
      '';
    };

  };


  config = mkIf (config.boot.enableContainers) (let

    unit = {
      description = "Container '%i'";

      unitConfig.RequiresMountsFor = "${stateDirectory}/%i";

      path = [ pkgs.iproute2 ];

      environment = {
        root = "${stateDirectory}/%i";
        INSTANCE = "%i";
      };

      preStart = preStartScript dummyConfig;

      script = startScript dummyConfig;

      postStart = postStartScript dummyConfig;

      restartIfChanged = false;

      serviceConfig = serviceDirectives dummyConfig;
    };
  in {
    warnings =
      (optional (config.virtualisation.containers.enable && versionOlder config.system.stateVersion "22.05") ''
        Enabling both boot.enableContainers & virtualisation.containers on system.stateVersion < 22.05 is unsupported.
      '');

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
            unitConfig.RequiresMountsFor = lib.optional (!containerConfig.ephemeral) "${stateDirectory}/%i";
            environment.root = if containerConfig.ephemeral then "/run/nixos-containers/%i" else "${stateDirectory}/%i";
          } // (
          if containerConfig.autoStart then
            {
              wantedBy = [ "machines.target" ];
              wants = [ "network.target" ];
              after = [ "network.target" ];
              restartTriggers = [
                containerConfig.path
                config.environment.etc."${configurationDirectoryName}/${name}.conf".source
              ];
              restartIfChanged = true;
            }
          else {})
      )) config.containers)
    ));

    # Generate a configuration file in /etc/nixos-containers for each
    # container so that container@.target can get the container
    # configuration.
    environment.etc =
      let mkPortStr = p: p.protocol + ":" + (toString p.hostPort) + ":" + (if p.containerPort == null then toString p.hostPort else toString p.containerPort);
      in mapAttrs' (name: cfg: nameValuePair "${configurationDirectoryName}/${name}.conf"
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

    environment.systemPackages = [
      (pkgs.nixos-container.override {
        inherit stateDirectory configurationDirectory;
      })
    ];

    boot.kernelModules = [
      "bridge"
      "macvlan"
      "tap"
      "tun"
    ];
  });
}
