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
      "/run/current-system/kernel-modules"
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

  mkDefaultAttrs = lib.mapAttrs (n: v: lib.mkDefault v);

  defaultNat64 = {
    instance = "default";
    framework = "netfilter";
    global.pool6 = "64:ff9b::/96";
  };
  defaultSiit = {
    instance = "default";
    framework = "netfilter";
  };

  nat64Conf = configFormat.generate "jool-nat64.conf" cfg.nat64.config;
  siitConf  = configFormat.generate "jool-siit.conf" cfg.siit.config;

in

{
  ###### interface

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
      '';
    };

    networking.jool.nat64.enable = lib.mkEnableOption (lib.mdDoc "a NAT64 instance of Jool.");
    networking.jool.nat64.config = lib.mkOption {
      type = configFormat.type;
      default = defaultNat64;
      example = lib.literalExpression ''
        {
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
            # Ports for dynamic translation
            { protocol =  "TCP";  prefix = "192.0.2.16/32"; "port range" = "40001-65535"; }
            { protocol =  "UDP";  prefix = "192.0.2.16/32"; "port range" = "40001-65535"; }
            { protocol = "ICMP";  prefix = "192.0.2.16/32"; "port range" = "40001-65535"; }

            # Ports for static BIB entries
            { protocol =  "TCP";  prefix = "192.0.2.16/32"; "port range" = "22"; }
            { protocol =  "UDP";  prefix = "192.0.2.16/32"; "port range" = "53"; }
          ];
        }
      '';
      description = lib.mdDoc ''
        The configuration of a stateful NAT64 instance of Jool managed through
        NixOS. See https://nicmx.github.io/Jool/en/config-atomic.html for the
        available options.

        ::: {.note}
        Existing or more instances created manually will not interfere with the
        NixOS instance, provided the respective `pool4` addresses and port
        ranges are not overlapping.
        :::

        ::: {.warning}
        Changes to the NixOS instance performed via `jool instance nixos-nat64`
        are applied correctly but will be lost after restarting
        `jool-nat64.service`.
        :::
      '';
    };

    networking.jool.siit.enable = lib.mkEnableOption (lib.mdDoc "a SIIT instance of Jool.");
    networking.jool.siit.config = lib.mkOption {
      type = configFormat.type;
      default = defaultSiit;
      example = lib.literalExpression ''
        {
          # Maps any IPv4 address x.y.z.t to 2001:db8::x.y.z.t and v.v.
          pool6 = "2001:db8::/96";

          # Explicit address mappings
          eamt = [
            # 2001:db8:1:: ←→ 192.0.2.0
            { "ipv6 prefix": "2001:db8:1::/128", "ipv4 prefix": "192.0.2.0" }
            # 2001:db8:1::x ←→ 198.51.100.x
            { "ipv6 prefix": "2001:db8:2::/120", "ipv4 prefix": "198.51.100.0/24" }
          ]
        }
      '';
      description = lib.mdDoc ''
        The configuration of a SIIT instance of Jool managed through
        NixOS. See https://nicmx.github.io/Jool/en/config-atomic.html for the
        available options.

        ::: {.note}
        Existing or more instances created manually will not interfere with the
        NixOS instance, provided the respective `EAMT` address mappings are not
        overlapping.
        :::

        ::: {.warning}
        Changes to the NixOS instance performed via `jool instance nixos-siit`
        are applied correctly but will be lost after restarting
        `jool-siit.service`.
        :::
      '';
    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ jool-cli ];
    boot.extraModulePackages = [ jool ];

    systemd.services.jool-nat64 = lib.mkIf cfg.nat64.enable {
      description = "Jool, NAT64 setup";
      documentation = [ "https://nicmx.github.io/Jool/en/documentation.html" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      reloadIfChanged = true;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStartPre = "${pkgs.kmod}/bin/modprobe jool";
        ExecStart    = "${jool-cli}/bin/jool file handle ${nat64Conf}";
        ExecStop     = "${jool-cli}/bin/jool -f ${nat64Conf} instance remove";
      } // hardening;
    };

    systemd.services.jool-siit = lib.mkIf cfg.siit.enable {
      description = "Jool, SIIT setup";
      documentation = [ "https://nicmx.github.io/Jool/en/documentation.html" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      reloadIfChanged = true;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStartPre = "${pkgs.kmod}/bin/modprobe jool_siit";
        ExecStart    = "${jool-cli}/bin/jool_siit file handle ${siitConf}";
        ExecStop     = "${jool-cli}/bin/jool_siit -f ${siitConf} instance remove";
      } // hardening;
    };

    system.checks = lib.singleton (pkgs.runCommand "jool-validated" {
      nativeBuildInputs = [ pkgs.buildPackages.jool-cli ];
      preferLocalBuild = true;
    } ''
      printf 'Validating Jool configuration... '
      ${lib.optionalString cfg.siit.enable "jool_siit file check ${siitConf}"}
      ${lib.optionalString cfg.nat64.enable "jool file check ${nat64Conf}"}
      printf 'ok\n'
      touch "$out"
    '');

    networking.jool.nat64.config = mkDefaultAttrs defaultNat64;
    networking.jool.siit.config  = mkDefaultAttrs defaultSiit;

  };

  meta.maintainers = with lib.maintainers; [ rnhmjoj ];

}
