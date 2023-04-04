{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.nixos.containers.instances;

  yesNo = x: if x then "yes" else "no";
  ifacePrefix = type: if type == "veth" then "ve" else "vz";

  dynamicAddrsDisabled = inst:
    inst.network == null || inst.network.v4.addrPool == [] && inst.network.v6.addrPool == [];

  mkRadvdSection = type: name: v6Pool:
    assert elem type [ "veth" "zone" ];
    ''
      interface ${ifacePrefix type}-${name} {
        AdvSendAdvert on;
        ${flip concatMapStrings v6Pool (x: ''
          prefix ${x} {
            AdvOnLink on;
            AdvAutonomous on;
          };
        '')}
      };
    '';

  zoneCfg = config.nixos.containers.zones;

  interfaces.containers = attrNames cfg;
  interfaces.zones = attrNames config.nixos.containers.zones;
  radvd = {
    enable = with interfaces; containers != [] || zones != [];
    config = concatStringsSep "\n" [
      (concatMapStrings
        (x: mkRadvdSection "veth" x cfg.${x}.network.v6.addrPool)
        (filter
          (n: cfg.${n}.network != null && cfg.${n}.zone == null)
          (attrNames cfg)))
      (concatMapStrings
        (x: mkRadvdSection "zone" x config.nixos.containers.zones.${x}.v6.addrPool)
        (attrNames config.nixos.containers.zones))
    ];
  };

  mkMatchCfg = type: name:
    assert elem type [ "veth" "zone" ]; {
      Name = "${ifacePrefix type}-${name}";
      Driver = if type == "veth" then "veth" else "bridge";
    };

  mkNetworkCfg = dhcp: { v4Nat, v6Nat }: {
    LinkLocalAddressing = mkDefault "ipv6";
    DHCPServer = yesNo dhcp;
    IPMasquerade =
      if v4Nat && v6Nat then "both"
      else if v4Nat then "ipv4"
      else if v6Nat then "ipv6"
      else "no";
    IPForward = "yes";
    LLDP = "yes";
    EmitLLDP = "customer-bridge";
    IPv6AcceptRA = "no";
  };

  mkStaticNetOpts = v:
    assert elem v [ 4 6 ]; {
      "v${toString v}".static = {
        hostAddresses = mkOption {
          default = [];
          type = types.listOf types.str;
          example = literalExpression (
            if v == 4 then ''[ "10.151.1.1/24" ]''
            else ''[ "fd23::/64" ]''
          );
          description = lib.mdDoc ''
            Address of the container on the host-side, i.e. the
            subnet and address assigned to `ve-<name>`.
          '';
        };
        containerPool = mkOption {
          default = [];
          type = types.listOf types.str;
          example = literalExpression (
            if v == 4 then ''[ "10.151.1.2/24" ]''
            else ''[ "fd23::2/64" ]''
          );

          description = lib.mdDoc ''
            Addresses to be assigned to the container, i.e. the
            subnet and address assigned to the `host0`-interface.
          '';
        };
      };
    };

  mkNetworkingOpts = type:
    let
      mkIPOptions = v: assert elem v [ 4 6 ]; {
        addrPool = mkOption {
          type = types.listOf types.str;
          default = if v == 4
            then [ "0.0.0.0/${toString (if type == "zone" then 24 else 28)}" ]
            else [ "::/64" ];

          description = lib.mdDoc ''
            Address pool to assign to a network. If
            `::/64` or `0.0.0.0/24` is specified,
            {manpage}`systemd.network(5)` will assign an ULA IPv6 or private IPv4 address from
            the address-pool of the given size to the interface.

            Please note that NATv6 is currently not supported since `IPMasquerade`
            doesn't support IPv6. If this is still needed, it's recommended to do it like this:

            ```ShellSession
            # ip6tables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
            ```
          '';
        };
        nat = mkOption {
          default = false;
          type = types.bool;
          description = lib.mdDoc ''
            Whether to set-up a basic NAT to enable internet access for the nspawn containers.
          '';
        };
      };
    in
      assert elem type [ "veth" "zone" ]; {
        v4 = mkIPOptions 4;
        v6 = mkIPOptions 6;
      } // optionalAttrs (type == "zone") {
        hostAddresses = mkOption {
          default = [];
          type = types.listOf types.str;
          description = lib.mdDoc ''
            Address of the container on the host-side, i.e. the
            subnet and address assigned to `vz-<name>`.
          '';
        };
      };

  mkImage = name: config: { container = config.system-config; inherit config; };

  mkContainer = cfg: let inherit (cfg) container config; in mkMerge [
    {
      execConfig = mkMerge [
        {
          Boot = false;
          Parameters = "${container.config.system.build.toplevel}/init";
          Ephemeral = yesNo config.ephemeral;
          KillSignal = "SIGRTMIN+3";
          X-ActivationStrategy = config.activation.strategy;
          PrivateUsers = mkDefault "pick";
        }
        (mkIf (!config.ephemeral) {
          LinkJournal = mkDefault "guest";
        })
      ];
      filesConfig = mkMerge [
        { PrivateUsersChown = mkDefault "yes"; }
        (mkIf config.sharedNix {
          BindReadOnly = [ "/nix/store" ] ++ optional config.mountDaemonSocket "/nix/var/nix/db";
        })
        (mkIf (config.sharedNix && config.mountDaemonSocket) {
          Bind = [ "/nix/var/nix/daemon-socket" ];
        })
      ];
      networkConfig = mkMerge [
        (mkIf (config.zone != null || config.network != null) {
          Private = true;
          VirtualEthernet = "yes";
        })
        (mkIf (config.zone != null) {
          Zone = config.zone;
        })
      ];
    }
    (mkIf (!config.sharedNix) {
      extraDrvConfig = let
        info = pkgs.closureInfo {
          rootPaths = [ container.config.system.build.toplevel ];
        };
      in pkgs.runCommand "bindmounts.nspawn" { }
        ''
          echo "[Files]" > $out

          cat ${info}/store-paths | while read line
          do
            echo "BindReadOnly=$line" >> $out
          done
        '';
    })
  ];

  images = mapAttrs mkImage cfg;
in {
  options.nixos.containers = {
    zones = mkOption {
      type = types.attrsOf (types.submodule {
        options = mkNetworkingOpts "zone";
      });
      default = {};
      description = lib.mdDoc ''
        Networking zones for nspawn containers. In this mode, the host-side
        of the virtual ethernet of a machine is managed by an interface named
        `vz-<name>`.
      '';
    };

    instances = mkOption {
      default = {};
      type = types.attrsOf (types.submodule ({ config, name, ... }: {
        options = {
          sharedNix = mkOption {
            default = true;
            type = types.bool;
            description = lib.mdDoc ''
              ::: {.warning}
                Experimental setting! Expect things to break!
              :::

              With this option **disabled**, only the needed store-paths will
              be mounted into the container rather than the entire store.
            '';
          };

          mountDaemonSocket = mkEnableOption (lib.mdDoc "daemon-socket in the container");

          timeoutStartSec = mkOption {
            type = types.str;
            default = "90s";
            description = lib.mdDoc ''
              Timeout for the startup of the container. Corresponds to `DefaultTimeoutStartSec`
              of {manpage}`systemd.system(5)`.
            '';
          };

          ephemeral = mkEnableOption "ephemeral container" // {
            description = lib.mdDoc ''
              `ephemeral` means that the container's rootfs will be wiped
              before every startup. See {manpage}`systemd.nspawn(5)` for further context.
            '';
          };

          nixpkgs = mkOption {
            default = ../../../..;
            type = types.path;
            description = lib.mdDoc ''
              Path to the `nixpkgs`-checkout or channel to use for the container.
            '';
          };

          zone = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = lib.mdDoc ''
              Name of the networking zone defined by {manpage}`systemd.nspawn(5)`.
            '';
          };

          credentials = mkOption {
            type = types.listOf (types.submodule {
              options = {
                id = mkOption {
                  type = types.str;
                  description = lib.mdDoc ''
                    ID of the credential under which the credential can be referenced by services
                    inside the container.
                  '';
                };
                path = mkOption {
                  type = types.str;
                  description = lib.mdDoc ''
                    Path or ID of the credential passed to the container.
                  '';
                };
              };
            });
            apply = concatMapStringsSep " " ({ id, path }: "--load-credential=${id}:${path}");
            default = [];
            description = lib.mdDoc ''
              Credentials using the `LoadCredential=`-feature from
              {manpage}`systemd.exec(5)`. These will be passed to the container's service-manager
              and can be used in a service inside a container like

              ```nix
              {
                systemd.services."service-name".serviceConfig.LoadCredential = "foo:foo";
              }
              ```

              where `foo` is the `id` of the credential passed to the container.

              See also {manpage}`systemd-nspawn(1)`.
            '';
          };

          activation = {
            strategy = mkOption {
              type = types.enum [ "none" "reload" "restart" "dynamic" ];
              default = "dynamic";
              description = lib.mdDoc ''
                Decide whether to **restart** or **reload**
                the container during activation.

                **dynamic** checks whether the `.nspawn`-unit
                has changed (apart from the init-script) and if that's the case, it will be
                restarted, otherwise a reload will happen.
              '';
            };

            reloadScript = mkOption {
              default = null;
              type = types.nullOr types.path;
              description = lib.mdDoc ''
                Script to run when a container is supposed to be reloaded.
              '';
            };
          };

          network = mkOption {
            type = types.nullOr (types.submodule {
              options = foldl recursiveUpdate {} [
                (mkNetworkingOpts "veth")
                (mkStaticNetOpts 4)
                (mkStaticNetOpts 6)
              ];
            });
            default = null;
            description = lib.mdDoc ''
              Networking options for a single container. With this option used, a
              `veth`-pair is created. It's possible to configure a dynamically
              managed network with private IPv4 and ULA IPv6 the same way like zones.
              Additionally, it's possible to statically assign addresses to a container here.
            '';
          };

          system-config = mkOption {
            description = lib.mdDoc ''
              NixOS configuration for the container. See {manpage}`configuration.nix(5)` for available options.
            '';
            default = {};
            type = mkOptionType {
              name = "NixOS configuration";
              merge = const (map (x: rec { imports = [ x.value ]; key = _file; _file = x.file; }));
            };
            apply = x: import "${config.nixpkgs}/nixos/lib/eval-config.nix" {
              system = pkgs.stdenv.hostPlatform.system;
              modules = [
                ./container-profile.nix
                ({ pkgs, ... }: {
                  networking.hostName = name;
                  systemd.network.networks."20-host0" = mkIf (config.network != null) {
                    address = with config.network; v4.static.containerPool ++ v6.static.containerPool;
                    networkConfig = mkIf (
                      config.zone != null
                        && zoneCfg.${config.zone}.v4.addrPool == []
                        && zoneCfg.${config.zone}.v6.addrPool == []
                      || config.network.v4.addrPool == []
                        && config.network.v6.addrPool == []
                    ) {
                      DHCP = "no";
                    };
                  };
                })
              ] ++ x;
              prefix = [ "nixos" "containers" "instances" name "system-config" ];
            };
          };
        };
      }));

      description = lib.mdDoc ''
        Attribute set to define {manpage}`systemd.nspawn(5)`-managed containers. With this attribute-set,
        a network, a shared store and a NixOS configuration can be declared for each running
        container.

        The container's state is managed in `/var/lib/machines/<name>`.
        A machine can be started with the
        `systemd-nspawn@<name>.service`-unit, during runtime it can
        be accessed with {manpage}`machinectl(1)`.

        Please note that if both [](#opt-nixos.containers.instances._name_.network)
        & [](#opt-nixos.containers.instances._name_.zone) are
        `null`, the container will use the host's network.
      '';
    };
  };

  config = mkIf (cfg != {}) {
    assertions = [
      { assertion = !config.boot.isContainer;
        message = ''
          Cannot start containers inside a container!
        '';
      }
      { assertion = config.networking.useNetworkd;
        message = "Only networkd is supported!";
      }
    ] ++ foldlAttrs (acc: n: inst: acc ++ [
      { assertion = inst.zone != null -> (config.nixos.containers.zones != null && config.nixos.containers.zones?${inst.zone});
        message = ''
          No configuration found for zone `${inst.zone}'!
          (Invalid container: ${n})
        '';
      }
      { assertion = inst.zone != null -> dynamicAddrsDisabled inst;
        message = ''
          Cannot assign additional generic address-pool to a veth-pair if corresponding
          container `${n}' already uses zone `${inst.zone}'!
        '';
      }
      { assertion = !inst.sharedNix -> ! (elem inst.activation.strategy [ "reload" "dynamic" ]);
        message = ''
          Cannot reload a container with `sharedNix' disabled! As soon as the
          `BindReadOnly='-options change, a config activation can't be done without a reboot
          (affected: ${n})!
        '';
      }
      { assertion = (inst.zone != null && inst.network != null) -> (inst.network.v4.static.hostAddresses ++ inst.network.v6.static.hostAddresses) == [];
        message = ''
          Container ${n} is in zone ${inst.zone}, but also attempts to define
          it's one host-side addresses. Use the host-side addresses of the zone instead.
        '';
      }
    ]) [ ] cfg;

    services = { inherit radvd; };

    systemd = {
      network.networks =
        foldlAttrs (acc: name: config: acc // optionalAttrs (config.network != null && config.zone == null) {
          "20-${ifacePrefix "veth"}-${name}" = {
            matchConfig = mkMatchCfg "veth" name;
            address = config.network.v4.addrPool
              ++ config.network.v6.addrPool
              ++ optionals (config.network.v4.static.hostAddresses != null)
                config.network.v4.static.hostAddresses
              ++ optionals (config.network.v6.static.hostAddresses != null)
                config.network.v6.static.hostAddresses;
            networkConfig = mkNetworkCfg (config.network.v4.addrPool != []) {
              v4Nat = config.network.v4.nat;
              v6Nat = config.network.v6.nat;
            };
          };
        }) { } cfg
        // foldlAttrs (acc: name: zone: acc // {
          "20-${ifacePrefix "zone"}-${name}" = {
            matchConfig = mkMatchCfg "zone" name;
            address = zone.v4.addrPool
              ++ zone.v6.addrPool
              ++ zone.hostAddresses;
            networkConfig = mkNetworkCfg true {
              v4Nat = zone.v4.nat;
              v6Nat = zone.v6.nat;
            };
          };
        }) { } config.nixos.containers.zones;

      nspawn = mapAttrs (const mkContainer) images;
      targets.machines.wants = map (x: "systemd-nspawn@${x}.service") (attrNames cfg);
      services = flip mapAttrs' cfg (container: { activation, timeoutStartSec, credentials, ... }:
        nameValuePair "systemd-nspawn@${container}" {
          preStart = mkBefore ''
            if [ ! -d /var/lib/machines/${container} ]; then
              mkdir -p /var/lib/machines/${container}/{etc,var,nix/var/nix}
              touch /var/lib/machines/${container}/etc/{os-release,machine-id}
            fi
          '';

          partOf = [ "machines.target" ];
          before = [ "machines.target" ];

          serviceConfig = mkMerge [
            { TimeoutStartSec = timeoutStartSec;
              # Inherit settings from `systemd-nspawn@.service`.
              # Workaround since settings from `systemd-nspawn@.service`-settings are not
              # picked up if an override exists and `systemd-nspawn@ldap` exists.
              RestartForceExitStatus = 133;
              Type = "notify";
              TasksMax = 16384;
              WatchdogSec = "3min";
              SuccessExitStatus = 133;
              Delegate = "yes";
              KillMode = "mixed";
              Slice = "machine.slice";
              DevicePolicy = "closed";
              DeviceAllow = [
                "/dev/net/tun rwm"
                "char-pts rw"
                "/dev/loop-control rw"
                "block-loop rw"
                "block-blkext rw"
                "/dev/mapper/control rw"
                "block-device-mapper rw"
              ];
              X-ActivationStrategy = activation.strategy;
              ExecStart = [
                ""
                "${config.systemd.package}/bin/systemd-nspawn ${credentials} --quiet --keep-unit --boot --network-veth --settings=override --machine=%i"
              ];
            }
            (mkIf (elem activation.strategy [ "reload" "dynamic" ]) {
              ExecReload = if activation.reloadScript != null
                then "${activation.reloadScript}"
                else "${pkgs.writeShellScript "activate" ''
                  pid=$(machinectl show ${container} --value --property Leader)
                  ${pkgs.util-linux}/bin/nsenter -t "$pid" -m -u -U -i -n -p \
                    -- ${images.${container}.container.config.system.build.toplevel}/bin/switch-to-configuration test
                ''}";
            })
          ];
        }
      );
    };
  };
}
