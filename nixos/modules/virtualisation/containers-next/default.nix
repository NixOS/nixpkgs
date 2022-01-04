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

  radvd.enable = "" != stringAsChars (x: if x == " " || x == "\n" then "" else x) radvd.config;

  radvd.config = ''
    ${concatMapStrings
      (x: mkRadvdSection "veth" x cfg.${x}.network.v6.addrPool)
      (filter
        (n: cfg.${n}.network != null && cfg.${n}.zone == null)
        (attrNames cfg))
    }
    ${concatMapStrings
      (x: mkRadvdSection "zone" x config.nixos.containers.zones.${x}.v6.addrPool)
      (attrNames config.nixos.containers.zones)
    }
  '';

  mkMatchCfg = type: name:
    assert elem type [ "veth" "zone" ]; {
      Name = "${ifacePrefix type}-${name}";
      Driver = if type == "veth" then "veth" else "bridge";
    };

  mkNetworkCfg = dhcp: nat: {
    LinkLocalAddressing = mkDefault "ipv6";
    DHCPServer = yesNo dhcp;
    IPMasquerade = yesNo nat;
    IPForward = "yes";
    LLDP = "yes";
    EmitLLDP = "customer-bridge";
    IPv6AcceptRA = "no";
  };

  recUpdate3 = a: b: c:
    recursiveUpdate a (recursiveUpdate b c);

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
          description = ''
            Address of the container on the host-side, i.e. the
            subnet and address assigned to <literal>ve-&lt;name&gt;</literal>.
          '';
        };
        containerPool = mkOption {
          default = [];
          type = types.listOf types.str;
          example = literalExpression (
            if v == 4 then ''[ "10.151.1.2/24" ]''
            else ''[ "fd23::2/64" ]''
          );

          description = ''
            Addresses to be assigned to the container, i.e. the
            subnet and address assigned to the <literal>host0</literal>-interface.
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

          description = ''
            Address pool to assign to a network. If
            <literal>::/64</literal> or <literal>0.0.0.0/24</literal> is specified,
            <citerefentry><refentrytitle>systemd.network</refentrytitle><manvolnum>5</manvolnum>
            </citerefentry> will assign an ULA IPv6 or private IPv4 address from
            the address-pool of the given size to the interface.

            Please note that NATv6 is currently not supported since <literal>IPMasquerade</literal>
            doesn't support IPv6. If this is still needed, it's recommended to do it like this:

            <screen>
            <prompt># </prompt>ip6tables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
            </screen>
          '';
        };
      } // (optionalAttrs (v == 4) {
        nat = mkOption {
          default = true;
          type = types.bool;
          description = ''
            Whether to set-up a basic NAT to enable internet access for the nspawn containers.
          '';
        };
      });
    in
      assert elem type [ "veth" "zone" ]; {
        v4 = mkIPOptions 4;
        v6 = mkIPOptions 6;
      } // optionalAttrs (type == "zone") {
        hostAddresses = mkOption {
          default = [];
          type = types.listOf types.str;
          description = ''
            Address of the container on the host-side, i.e. the
            subnet and address assigned to <literal>vz-&lt;name&gt;</literal>.
          '';
        };
      };

  mkImage = name: config:
    { container = import "${toString config.nixpkgs}/nixos/lib/eval-config.nix" {
        system = pkgs.stdenv.hostPlatform.system;
        modules = [
          ./container-profile.nix
          ({ pkgs, ... }: {
            networking.hostName = name;
            systemd.network.networks."20-host0" = {
              address = mkIf (cfg.${name}.network != null) (
                cfg.${name}.network.v4.static.containerPool
                ++ cfg.${name}.network.v6.static.containerPool
              );
            };
          })
        ] ++ (config.system-config);
        prefix = [ "nixos" "containers" "instances" name "config" ];
      };
      inherit config;
    };

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
          BindReadOnly = [ "/nix/store" "/nix/var/nix/db" "/nix/var/nix/daemon-socket" ];
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
        (mkIf (config.forwardPorts != []) {
          Port = config.forwardPorts;
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
      description = ''
        Networking zones for nspawn containers. In this mode, the host-side
        of the virtual ethernet of a machine is managed by an interface named
        <literal>vz-&lt;name&gt;</literal>.
      '';
    };

    rendered = mkOption {
      type = types.attrsOf (types.attrsOf types.unspecified);
      readOnly = true;
      description = ''
        Fully rendered configuration of each container. Helpful to introspect the config
        from outside.
      '';
    };

    instances = mkOption {
      default = {};
      type = types.attrsOf (types.submodule {
        options = {
          sharedNix = mkOption {
            default = true;
            type = types.bool;
            description = ''
              <warning>
                <para>Experimental setting! Expect things to break!</para>
              </warning>

              With this option <emphasis>disabled</emphasis>, only the needed store-paths will
              be mounted into the container rather than the entire store.
            '';
          };

          ephemeral = mkEnableOption "ephemeral container" // {
            description = ''
              <literal>ephemeral</literal> means that the container's rootfs will be wiped
              before every startup. See <citerefentry><refentrytitle>systemd.nspawn</refentrytitle>
              <manvolnum>5</manvolnum></citerefentry> for further context.
            '';
          };

          nixpkgs = mkOption {
            default = ../../../..;
            type = types.path;
            description = ''
              Path to the `nixpkgs`-checkout or channel to use for the container.
            '';
          };

          zone = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = ''
              Name of the networking zone defined by <citerefentry>
              <refentrytitle>systemd.nspawn</refentrytitle><manvolnum>5</manvolnum></citerefentry>.
            '';
          };

          credentials = mkOption {
            type = types.listOf (types.submodule {
              options = {
                id = mkOption {
                  type = types.str;
                  description = ''
                    ID of the credential under which the credential can be referenced by services
                    inside the container.
                  '';
                };
                path = mkOption {
                  type = types.str;
                  description = ''
                    Path or ID of the credential passed to the container.
                  '';
                };
              };
            });
            apply = concatMapStringsSep " " ({ id, path }: "--load-credential=${id}:${path}");
            default = [];
            description = ''
              Credentials using the <literal>LoadCredential=</literal>-feature from
              <citerefentry><refentrytitle>systemd.exec</refentrytitle><manvolnum>5</manvolnum>
              </citerefentry>. These will be passed to the container's service-manager
              and can be used in a service inside a container like

              <programlisting>
              {
                <xref linkend="opt-systemd.services._name_.serviceConfig" />.LoadCredential = "foo:foo";
              }
              </programlisting>

              where <literal>foo</literal> is the
              <xref linkend="opt-nixos.containers.instances._name_.credentials._.id" /> of the
              credential passed to the container.

              See also <citerefentry><refentrytitle>systemd-nspawn</refentrytitle>
              <manvolnum>1</manvolnum></citerefentry>.
            '';
          };

          activation = {
            strategy = mkOption {
              type = types.enum [ "none" "reload" "restart" "dynamic" ];
              default = "dynamic";
              description = ''
                Decide whether to <emphasis>restart</emphasis> or <emphasis>reload</emphasis>
                the container during activation.

                <literal>dynamic</literal> checks whether the <filename>.nspawn</filename>-unit
                has changed (apart from the init-script) and if that's the case, it will be
                rebooted, otherwise a restart will happen.
              '';
            };

            reloadScript = mkOption {
              default = null;
              type = types.nullOr types.path;
              description = ''
                Script to run when a container is supposed to be reloaded.
              '';
            };
          };

          network = mkOption {
            type = types.nullOr (types.submodule {
              options = recUpdate3
                (mkNetworkingOpts "veth")
                (mkStaticNetOpts 4)
                (mkStaticNetOpts 6);
            });
            default = null;
            description = ''
              Networking options for a single container. With this option used, a
              <literal>veth</literal>-pair is created. It's possible to configure a dynamically
              managed network with private IPv4 and ULA IPv6 the same way like zones.
              Additionally, it's possible to statically assign addresses to a container here.
            '';
          };

          forwardPorts = mkOption {
            default = [];
            example = literalExpression
              ''
                [
                  { containerPort = 80; hostPort = 8080; protocol = "tcp"; }
                ]
              '';

            type = types.listOf (types.submodule {
              options = {
                containerPort = mkOption {
                  type = types.nullOr types.port;
                  default = null;
                  description = ''
                    Port to forward on the container-side. If <literal>null</literal>, the
                    <xref linkend="opt-nixos.containers.instances._name_.forwardPorts._.hostPort" />-option
                    will be used.
                  '';
                };

                hostPort = mkOption {
                  type = types.port;
                  description = ''
                    Source port on the host-side.
                  '';
                };

                protocol = mkOption {
                  default = "tcp";
                  type = types.enum [ "udp" "tcp" ];
                  description = ''
                    Protocol specifier for the port-forward between host and container.
                  '';
                };
              };
            });

            apply = map
              ({ containerPort ? null, hostPort, protocol }:
                let
                  host = toString hostPort;
                  container = if containerPort == null then host else toString containerPort;
                in
                  "${protocol}:${host}:${container}");

            description = ''
              Define port-forwarding from a container to host. See <literal>--port</literal>-section
              of <citerefentry><refentrytitle>systemd-nspawn</refentrytitle><manvolnum>1</manvolnum>
              </citerefentry> for further information.
            '';
          };

          system-config = mkOption {
            description = ''
              NixOS configuration for the container. See <citerefentry>
              <refentrytitle>configuration.nix</refentrytitle><manvolnum>5</manvolnum>
              </citerefentry> for available options.
            '';
            default = {};
            type = mkOptionType {
              name = "NixOS configuration";
              merge = const (map (x: rec { imports = [ x.value ]; key = _file; _file = x.file; }));
            };
          };
        };
      });

      description = ''
        Attribute set to define <citerefentry><refentrytitle>systemd.nspawn</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry>-managed containers. With this attribute-set,
        a network, a shared store and a NixOS configuration can be declared for each running
        container.

        The container's state is managed in <filename>/var/lib/machines/&lt;name&gt;</filename>.
        A machine can be started with the
        <filename>systemd-nspawn@&lt;name&gt;.service</filename>-unit, during runtime it can
        be accessed with <citerefentry><refentrytitle>machinectl</refentrytitle>
        <manvolnum>1</manvolnum></citerefentry>.

        Please note that if both <xref linkend="opt-nixos.containers.instances._name_.network" />
        &amp; <xref linkend="opt-nixos.containers.instances._name_.zone" /> are
        <literal>null</literal>, the container will use the host's network.
      '';
    };
  };

  config = mkIf (cfg != {}) {
    assertions = [
      { assertion = !config.boot.isContainer;
        description = ''
          Cannot start containers inside a container!
        '';
      }
      { assertion = config.networking.useNetworkd;
        description = "Only networkd is supported!";
      }
    ] ++ (flip concatMap (attrNames config.nixos.containers.instances) (n: let inst = cfg.${n}; in [
      { assertion = inst.zone != null -> (config.nixos.containers.zones != null && config.nixos.containers.zones ? ${inst.zone});
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
      { assertion = !inst.sharedNix -> inst.activation.strategy != "reload";
        message = ''
          Cannot reload a container with `sharedNix' disabled! As soon as the
          `BindReadOnly='-options change, a config activation can't be done without a reboot
          (affected: ${n})!
        '';
      }
    ]));

    services.radvd = {
      inherit (radvd) config enable;
    };

    nixos.containers.rendered = mapAttrs (const (x: x.container)) images;

    systemd = {
      network.networks = mkMerge
        ((flip mapAttrsToList cfg (name: config: optionalAttrs (config.network != null && config.zone == null) {
          "20-${ifacePrefix "veth"}-${name}" = {
            matchConfig = mkMatchCfg "veth" name;
            address = config.network.v4.addrPool
              ++ config.network.v6.addrPool
              ++ optionals (config.network.v4.static.hostAddresses != null)
                config.network.v4.static.hostAddresses
              ++ optionals (config.network.v6.static.hostAddresses != null)
                config.network.v6.static.hostAddresses;
            networkConfig = mkNetworkCfg (config.network.v4.addrPool != []) config.network.v4.nat;
          };
        }))
        ++ (flip mapAttrsToList config.nixos.containers.zones (name: zone: {
          "20-${ifacePrefix "zone"}-${name}" = {
            matchConfig = mkMatchCfg "zone" name;
            address = zone.v4.addrPool
              ++ zone.v6.addrPool
              ++ zone.hostAddresses
              ++ (flatten (flip mapAttrsToList cfg
                (name: config: optionals (config.zone != null && config.network != null)
                  (config.network.v4.static.hostAddresses ++ config.network.v6.static.hostAddresses)
                )));
            networkConfig = mkNetworkCfg true zone.v4.nat;
          };
        })));

      nspawn = mapAttrs (const mkContainer) images;
      targets.machines.wants = map (x: "systemd-nspawn@${x}.service") (attrNames cfg);
      services = listToAttrs (flip map (attrNames cfg) (container:
        let
          inherit (cfg.${container}) activation credentials;
        in nameValuePair "systemd-nspawn@${container}" {
          preStart = mkBefore ''
            if [ ! -d /var/lib/machines/${container} ]; then
              mkdir -p /var/lib/machines/${container}/{etc,var,nix/var/nix}
              touch /var/lib/machines/${container}/etc/{os-release,machine-id} || true
            fi
          '';

          partOf = [ "machines.target" ];
          before = [ "machines.target" ];

          serviceConfig = mkMerge [
            {
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
                else "${pkgs.writeShellScriptBin "activate" ''
                  pid=$(machinectl show ${container} --value --property Leader)
                  ${pkgs.util-linux}/bin/nsenter -t "$pid" -m -u -U -i -n -p \
                    -- ${images.${container}.container.config.system.build.toplevel}/bin/switch-to-configuration test
                ''}/bin/activate";
            })
          ];
        }
      ));
    };
  };
}
