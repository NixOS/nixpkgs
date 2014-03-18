{ config, pkgs, ... }:

with pkgs.lib;

let

  runInNetns = pkgs.stdenv.mkDerivation {
    name = "run-in-netns";
    unpackPhase = "true";
    buildPhase = ''
      mkdir -p $out/bin
      gcc ${./run-in-netns.c} -o $out/bin/run-in-netns
    '';
    installPhase = "true";
  };

  nixos-container-shell = pkgs.writeScriptBin "nixos-container-shell"
    ''
      #! ${pkgs.bash}/bin/sh -e

      usage() {
        echo "Usage: $0 <container-name>" >&2
        echo "       $0 (-r|--root-shell) <container-name>" >&2
      }

      args="`getopt --options 'r' -l help -- "$@"`"
      eval "set -- $args"
      rootShell=
      while [ $# -gt 0 ]; do
        case "$1" in
          (--help) usage; exit 0;;
          (-r|--root-shell) rootShell=1;;
          (--) shift; break;;
          (*) break;;
        esac
        shift
      done

      container="$1"
      if [ -z "$container" ]; then
        usage
        exit 1
      fi
      shift

      root="/var/lib/containers/$container"
      if ! [ -d "$root" ]; then
        echo "$0: container ‘$container’ does not exist" >&2
        exit 1
      fi

      if [ -n "$rootShell" ]; then
        socket="$root/var/lib/root-shell.socket"
      else
        socket="$root/var/lib/login.socket"
      fi
      if ! [ -S "$socket" ]; then
        echo "$0: socket ‘$socket’ does not exist" >&2
        exit 1
      fi

      if [ -n "$rootShell" ]; then
        exec ${pkgs.socat}/bin/socat "unix:$socket" -
      else
        exec ${pkgs.socat}/bin/socat "unix:$socket" -,echo=0,raw
      fi
    '';

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

    systemd.containers = mkOption {
      type = types.attrsOf (types.submodule (
        { config, options, name, ... }:
        {
          options = {

            root = mkOption {
              type = types.path;
              description = ''
                The root directory of the container.
              '';
            };

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
                <literal>c-<replaceable>container-name</replaceable></literal>
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
            [ { root = mkDefault "/var/lib/containers/${name}";
              }
              (mkIf options.config.isDefined {
                path = (import ../../lib/eval-config.nix {
                  modules =
                    let extraConfig =
                      { boot.isContainer = true;
                        security.initialRootPassword = mkDefault "!";
                        networking.hostName = mkDefault name;
                        networking.useDHCP = false;
                        imports = [ ./container-login.nix ];
                      };
                    in [ extraConfig config.config ];
                  prefix = [ "systemd" "containers" name ];
                }).config.system.build.toplevel;
              })
            ];
        }));

      default = {};
      example = literalExample
        ''
          { webserver =
              { root = "/containers/webserver";
                path = "/nix/var/nix/profiles/webserver";
              };
            database =
              { root = "/containers/database";
                config =
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


  config = {

    systemd.services = mapAttrs' (name: cfg:
      let
        # FIXME: interface names have a maximum length.
        ifaceHost = "c-${name}";
        ifaceCont = "ctmp-${name}";
        ns = "net-${name}";
      in
      nameValuePair "container-${name}" {
        description = "Container '${name}'";

        wantedBy = [ "multi-user.target" ];

        unitConfig.RequiresMountsFor = [ cfg.root ];

        path = [ pkgs.iproute ];

        preStart =
          ''
            mkdir -p -m 0755 ${cfg.root}/etc
            if ! [ -e ${cfg.root}/etc/os-release ]; then
              touch ${cfg.root}/etc/os-release
            fi

            mkdir -p -m 0755 \
              /nix/var/nix/profiles/per-container/${name} \
              /nix/var/nix/gcroots/per-container/${name}
          ''

          + optionalString (cfg.root != "/var/lib/containers/${name}") ''
            ln -sfn "${cfg.root}" "/var/lib/containers/${name}"
          ''

          + optionalString cfg.privateNetwork ''
            # Cleanup from last time.
            ip netns del ${ns} 2> /dev/null || true
            ip link del ${ifaceHost} 2> /dev/null || true
            ip link del ${ifaceCont} 2> /dev/null || true

            # Create a pair of virtual ethernet devices.  On the host,
            # we get ‘c-<container-name’, and on the guest, we get
            # ‘eth0’.
            set -x
            ip link add ${ifaceHost} type veth peer name ${ifaceCont}
            ip netns add ${ns}
            ip link set ${ifaceCont} netns ${ns}
            ip netns exec ${ns} ip link set ${ifaceCont} name eth0
            ip netns exec ${ns} ip link set dev eth0 up
            ip link set dev ${ifaceHost} up
            ${optionalString (cfg.hostAddress != null) ''
              ip addr add ${cfg.hostAddress} dev ${ifaceHost}
              ip netns exec ${ns} ip route add ${cfg.hostAddress} dev eth0
              ip netns exec ${ns} ip route add default via ${cfg.hostAddress}
            ''}
            ${optionalString (cfg.localAddress != null) ''
              ip netns exec ${ns} ip addr add ${cfg.localAddress} dev eth0
              ip route add ${cfg.localAddress} dev ${ifaceHost}
            ''}
          '';

        serviceConfig.ExecStart =
          (optionalString cfg.privateNetwork "${runInNetns}/bin/run-in-netns ${ns} ")
          + "${config.systemd.package}/bin/systemd-nspawn"
          + (optionalString cfg.privateNetwork " --capability=CAP_NET_ADMIN")
          + " -M ${name} -D ${cfg.root}"
          + " --bind-ro=/nix/store --bind-ro=/nix/var/nix/db --bind-ro=/nix/var/nix/daemon-socket"
          + " --bind=/nix/var/nix/profiles/per-container/${name}:/nix/var/nix/profiles"
          + " --bind=/nix/var/nix/gcroots/per-container/${name}:/nix/var/nix/gcroots"
          + " ${cfg.path}/init";

        preStop =
          ''
            pid="$(cat /sys/fs/cgroup/systemd/machine/${name}.nspawn/system/tasks 2> /dev/null)"
            if [ -n "$pid" ]; then
              # Send the RTMIN+3 signal, which causes the container
              # systemd to start halt.target.
              echo "killing container systemd, PID = $pid"
              kill -RTMIN+3 $pid
              # Wait for the container to exit.  We can't let systemd
              # do this because it will send a signal to the entire
              # cgroup.
              for ((n = 0; n < 180; n++)); do
                if ! kill -0 $pid 2> /dev/null; then break; fi
                sleep 1
              done
            fi
          '';

        reloadIfChanged = true;

        serviceConfig.ExecReload =
          "${pkgs.bash}/bin/bash -c '"
          + "echo ${cfg.path}/bin/switch-to-configuration test "
          + "| ${pkgs.socat}/bin/socat unix:${cfg.root}/var/lib/root-shell.socket -'";

      }) config.systemd.containers;

    # Generate /etc/hosts entries for the containers.
    networking.extraHosts = concatStrings (mapAttrsToList (name: cfg: optionalString (cfg.localAddress != null)
      ''
        ${cfg.localAddress} ${name}.containers
      '') config.systemd.containers);

    environment.systemPackages = optional (config.systemd.containers != {}) nixos-container-shell;

  };
}
