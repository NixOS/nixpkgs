{ config, lib, ... }:

let
  cfg = config.services.quad9;

  # Quad9 service variants: addresses and the TLS hostname (SNI) for each
  variants = {
    secure = {
      sni = "dns.quad9.net";
      ipv4 = [
        "9.9.9.9"
        "149.112.112.112"
      ];
      ipv6 = [
        "2620:fe::fe"
        "2620:fe::9"
      ];
    };
    unfiltered = {
      sni = "dns10.quad9.net";
      ipv4 = [
        "9.9.9.10"
        "149.112.112.10"
      ];
      ipv6 = [
        "2620:fe::10"
        "2620:fe::fe:10"
      ];
    };
    ecs = {
      sni = "dns11.quad9.net";
      ipv4 = [
        "9.9.9.11"
        "149.112.112.11"
      ];
      ipv6 = [
        "2620:fe::11"
        "2620:fe::fe:11"
      ];
    };
  };

  variant = variants.${cfg.variant};

  addresses = variant.ipv4 ++ lib.optionals cfg.ipv6 variant.ipv6;

  # With DoT, append "#hostname" so systemd-resolved can verify the certificate.
  servers = if cfg.dnsOverTls then map (a: "${a}#${variant.sni}") addresses else addresses;

  resolved = config.services.resolved.enable;
in
{
  options.services.quad9 = {
    enable = lib.mkEnableOption "Quad9 as the system DNS resolver";

    variant = lib.mkOption {
      type = lib.types.enum (lib.attrNames variants);
      default = "secure";
      description = ''
        Which Quad9 service to use:

        - `secure`: malware blocking and DNSSEC validation (9.9.9.9)
        - `unfiltered`: no malware blocking and no DNSSEC validation (9.9.9.10)
        - `ecs`: malware blocking, DNSSEC validation and EDNS Client Subnet (9.9.9.11)

        See <https://quad9.net/service/service-addresses-and-features>.
      '';
    };

    ipv6 = lib.mkOption {
      type = lib.types.bool;
      default = config.networking.enableIPv6;
      defaultText = lib.literalExpression "config.networking.enableIPv6";
      description = "Whether to include the IPv6 addresses of Quad9.";
    };

    dnsOverTls = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to encrypt DNS queries with DNS-over-TLS.  This enables
        systemd-resolved, which also verifies the certificate of Quad9.

        The setting becomes the default for every link, so DNS servers
        obtained through DHCP are contacted over TLS as well.  Names that only
        such a server knows, for example hosts on the local network, therefore
        do not resolve unless DNS-over-TLS is disabled for that link.
      '';
    };

    dnssec = lib.mkOption {
      type = lib.types.enum [
        "true"
        "allow-downgrade"
        "false"
      ];
      default = "allow-downgrade";
      description = ''
        Local DNSSEC validation mode of systemd-resolved, see `DNSSEC=` in
        {manpage}`resolved.conf(5)`.  Only applies when systemd-resolved is
        enabled.
      '';
    };

    overrideDhcp = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to prevent DNS servers provided by DHCP or NetworkManager from
        taking over.

        With systemd-resolved, Quad9 becomes the preferred route for all
        domains, and per-link DNS servers only answer for their own search
        domains.  Otherwise, dhcpcd and NetworkManager are kept from rewriting
        {file}`/etc/resolv.conf`.
      '';
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        networking.nameservers = servers;

        # DNS-over-TLS is implemented by systemd-resolved
        services.resolved.enable = lib.mkIf cfg.dnsOverTls true;
      }

      (lib.mkIf resolved {
        services.resolved.settings.Resolve = {
          DNSOverTLS = lib.mkIf cfg.dnsOverTls (lib.mkDefault true);
          DNSSEC = lib.mkDefault cfg.dnssec;
          FallbackDNS = lib.mkDefault servers;
          # Prefer the global servers over per-link ones for every domain
          Domains = lib.mkIf cfg.overrideDhcp (config.networking.search ++ [ "~." ]);
        };
      })

      # Without systemd-resolved, keep DHCP clients from rewriting /etc/resolv.conf
      (lib.mkIf (cfg.overrideDhcp && !resolved) {
        networking.networkmanager.dns = lib.mkDefault "none";
        networking.dhcpcd.extraConfig = "nohook resolv.conf";
      })
    ]
  );

  meta.maintainers = with lib.maintainers; [ yiyu ];
}
