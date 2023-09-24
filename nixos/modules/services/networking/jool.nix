{ config, pkgs, lib, ... }:

let
  cfg = config.networking.jool;

  jool = config.boot.kernelPackages.jool;
  jool-cli = pkgs.jool-cli;

  hardening = {
    # Run as unprivileged user
    User = "jool";
    Group = "jool";
    DynamicUser = true;

    # Restrict filesystem to only read the jool module
    TemporaryFileSystem = [ "/" ];
    BindReadOnlyPaths = [
      builtins.storeDir
      "/run/booted-system/kernel-modules"
    ];

    # Give capabilities to load the module and configure it
    AmbientCapabilities = [ "CAP_SYS_MODULE" "CAP_NET_ADMIN" ];
    RestrictAddressFamilies = [ "AF_NETLINK" ];

    # Other restrictions
    RestrictNamespaces = [ "net" ];
    SystemCallFilter = [ "@system-service" "@module" ];
    CapabilityBoundingSet = [ "CAP_SYS_MODULE" "CAP_NET_ADMIN" ];
  };

  configFormat = pkgs.formats.json {};

  # Generate the config file of instance `name`
  nat64Conf = name:
    configFormat.generate "jool-nat64-${name}.conf"
      (cfg.nat64.${name} // { instance = name; });
  siitConf = name:
    configFormat.generate "jool-siit-${name}.conf"
      (cfg.siit.${name} // { instance = name; });

  # NAT64 config type
  nat64Options = lib.types.submodule {
    # The format is plain JSON
    freeformType = configFormat.type;
    # Some options with a default value
    options.framework = lib.mkOption {
      type = lib.types.enum [ "netfilter" "iptables" ];
      default = "netfilter";
      description = lib.mdDoc ''
        The framework to use for attaching Jool's translation to the exist
        kernel packet processing rules. See the
        [documentation](https://nicmx.github.io/Jool/en/intro-jool.html#design)
        for the differences between the two options.
      '';
    };
    options.global.pool6 = lib.mkOption {
      type = lib.types.strMatching "[[:xdigit:]:]+/[[:digit:]]+"
        // { description = "Network prefix in CIDR notation"; };
      default = "64:ff9b::/96";
      description = lib.mdDoc ''
        The prefix used for embedding IPv4 into IPv6 addresses.
        Defaults to the well-known NAT64 prefix, defined by
        [RFC 6052](https://datatracker.ietf.org/doc/html/rfc6052).
      '';
    };
  };

  # SIIT config type
  siitOptions = lib.types.submodule {
    # The format is, again, plain JSON
    freeformType = configFormat.type;
    # Some options with a default value
    options = { inherit (nat64Options.getSubOptions []) framework; };
  };

  makeNat64Unit = name: opts: {
    "jool-nat64-${name}" = {
      description = "Jool, NAT64 setup of instance ${name}";
      documentation = [ "https://nicmx.github.io/Jool/en/documentation.html" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStartPre = "${pkgs.kmod}/bin/modprobe jool";
        ExecStart    = "${jool-cli}/bin/jool file handle ${nat64Conf name}";
        ExecStop     = "${jool-cli}/bin/jool -f ${nat64Conf name} instance remove";
      } // hardening;
    };
  };

  makeSiitUnit = name: opts: {
    "jool-siit-${name}" = {
      description = "Jool, SIIT setup of instance ${name}";
      documentation = [ "https://nicmx.github.io/Jool/en/documentation.html" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStartPre = "${pkgs.kmod}/bin/modprobe jool_siit";
        ExecStart    = "${jool-cli}/bin/jool_siit file handle ${siitConf name}";
        ExecStop     = "${jool-cli}/bin/jool_siit -f ${siitConf name} instance remove";
      } // hardening;
    };
  };

  checkNat64 = name: _: ''
    printf 'Validating Jool configuration for NAT64 instance "${name}"... '
    jool file check ${nat64Conf name}
    printf 'Ok.\n'; touch "$out"
  '';

  checkSiit = name: _: ''
    printf 'Validating Jool configuration for SIIT instance "${name}"... '
    jool_siit file check ${siitConf name}
    printf 'Ok.\n'; touch "$out"
  '';

in

{
  options = {
    networking.jool.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      relatedPackages = [ "linuxPackages.jool" "jool-cli" ];
      description = lib.mdDoc ''
        Whether to enable Jool, an Open Source implementation of IPv4/IPv6
        translation on Linux.

        Jool can perform stateless IP/ICMP translation (SIIT) or stateful
        NAT64, analogous to the IPv4 NAPT. Refer to the upstream
        [documentation](https://nicmx.github.io/Jool/en/intro-xlat.html) for
        the supported modes of translation and how to configure them.

        Enabling this option will install the Jool kernel module and the
        command line tools for controlling it.
      '';
    };

    networking.jool.nat64 = lib.mkOption {
      type = lib.types.attrsOf nat64Options;
      default = { };
      example = lib.literalExpression ''
        {
          default = {
            # custom NAT64 prefix
            global.pool6 = "2001:db8:64::/96";

            # Port forwarding
            bib = [
              { # SSH 192.0.2.16 → 2001:db8:a::1
                "protocol"     = "TCP";
                "ipv4 address" = "192.0.2.16#22";
                "ipv6 address" = "2001:db8:a::1#22";
              }
              { # DNS (TCP) 192.0.2.16 → 2001:db8:a::2
                "protocol"     = "TCP";
                "ipv4 address" = "192.0.2.16#53";
                "ipv6 address" = "2001:db8:a::2#53";
              }
              { # DNS (UDP) 192.0.2.16 → 2001:db8:a::2
                "protocol" = "UDP";
                "ipv4 address" = "192.0.2.16#53";
                "ipv6 address" = "2001:db8:a::2#53";
              }
            ];

            pool4 = [
              # Port ranges for dynamic translation
              { protocol =  "TCP";  prefix = "192.0.2.16/32"; "port range" = "40001-65535"; }
              { protocol =  "UDP";  prefix = "192.0.2.16/32"; "port range" = "40001-65535"; }
              { protocol = "ICMP";  prefix = "192.0.2.16/32"; "port range" = "40001-65535"; }

              # Ports for static BIB entries
              { protocol =  "TCP";  prefix = "192.0.2.16/32"; "port range" = "22"; }
              { protocol =  "UDP";  prefix = "192.0.2.16/32"; "port range" = "53"; }
            ];
          };
        }
      '';
      description = lib.mdDoc ''
        Definitions of NAT64 instances of Jool.
        See the
        [documentation](https://nicmx.github.io/Jool/en/config-atomic.html) for
        the available options. Also check out the
        [tutorial](https://nicmx.github.io/Jool/en/run-nat64.html) for an
        introduction to NAT64 and how to troubleshoot the setup.

        The attribute name defines the name of the instance, with the main one
        being `default`: this can be accessed from the command line without
        specifying the name with `-i`.

        ::: {.note}
        Instances created imperatively from the command line will not interfere
        with the NixOS instances, provided the respective `pool4` addresses and
        port ranges are not overlapping.
        :::

        ::: {.warning}
        Changes to an instance performed via `jool -i <name>` are applied
        correctly but will be lost after restarting the respective
        `jool-nat64-<name>.service`.
        :::
      '';
    };

    networking.jool.siit = lib.mkOption {
      type = lib.types.attrsOf siitOptions;
      default = { };
      example = lib.literalExpression ''
        {
          default = {
            # Maps any IPv4 address x.y.z.t to 2001:db8::x.y.z.t and v.v.
            global.pool6 = "2001:db8::/96";

            # Explicit address mappings
            eamt = [
              # 2001:db8:1:: ←→ 192.0.2.0
              { "ipv6 prefix" = "2001:db8:1::/128"; "ipv4 prefix" = "192.0.2.0"; }
              # 2001:db8:1::x ←→ 198.51.100.x
              { "ipv6 prefix" = "2001:db8:2::/120"; "ipv4 prefix" = "198.51.100.0/24"; }
            ];
          };
        }
      '';
      description = lib.mdDoc ''
        Definitions of SIIT instances of Jool.
        See the
        [documentation](https://nicmx.github.io/Jool/en/config-atomic.html) for
        the available options. Also check out the
        [tutorial](https://nicmx.github.io/Jool/en/run-vanilla.html) for an
        introduction to SIIT and how to troubleshoot the setup.

        The attribute name defines the name of the instance, with the main one
        being `default`: this can be accessed from the command line without
        specifying the name with `-i`.

        ::: {.note}
        Instances created imperatively from the command line will not interfere
        with the NixOS instances, provided the respective EAMT addresses and
        port ranges are not overlapping.
        :::

        ::: {.warning}
        Changes to an instance performed via `jool -i <name>` are applied
        correctly but will be lost after restarting the respective
        `jool-siit-<name>.service`.
        :::
      '';
    };

  };

  config = lib.mkIf cfg.enable {
    # Install kernel module and cli tools
    boot.extraModulePackages = [ jool ];
    environment.systemPackages = [ jool-cli ];

    # Install services for each instance
    systemd.services = lib.mkMerge
      (lib.mapAttrsToList makeNat64Unit cfg.nat64 ++
       lib.mapAttrsToList makeSiitUnit cfg.siit);

    # Check the configuration of each instance
    system.checks = lib.optional (cfg.nat64 != {} || cfg.siit != {})
      (pkgs.runCommand "jool-validated"
        {
          nativeBuildInputs = with pkgs.buildPackages; [ jool-cli ];
          preferLocalBuild = true;
        }
        (lib.concatStrings
          (lib.mapAttrsToList checkNat64 cfg.nat64 ++
           lib.mapAttrsToList checkSiit cfg.siit)));
  };

  meta.maintainers = with lib.maintainers; [ rnhmjoj ];

}
