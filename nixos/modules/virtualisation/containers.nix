{ config, pkgs, ... }:

with pkgs.lib;

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

          };

          config = mkMerge
            [ { root = mkDefault "/var/lib/containers/${name}";
              }
              (mkIf options.config.isDefined {
                path = (import ../../lib/eval-config.nix {
                  modules =
                    let extraConfig =
                      { boot.isContainer = true;
                        security.initialRootPassword = "!";
                        networking.hostName = mkDefault name;
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

    systemd.services = mapAttrs' (name: container: nameValuePair "container-${name}"
      { description = "Container '${name}'";

        wantedBy = [ "multi-user.target" ];

        unitConfig.RequiresMountsFor = [ container.root ];

        preStart =
          ''
            mkdir -p -m 0755 ${container.root}/etc
            if ! [ -e ${container.root}/etc/os-release ]; then
              touch ${container.root}/etc/os-release
            fi
          '';

        serviceConfig.ExecStart =
          "${config.systemd.package}/bin/systemd-nspawn -M ${name} -D ${container.root} --bind-ro=/nix ${container.path}/init";

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
      }) config.systemd.containers;

  };
}