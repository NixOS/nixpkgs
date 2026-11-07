{ formats }:
{
  config,
  lib,
  options,
  ...
}:
let
  cfg = config.kea-dhcp-dns;
  format = formats.json { };
in
{
  options.kea-dhcp-dns = {
    package = lib.mkOption {
      type = lib.types.package;
      description = "The package you want to use.";
    };

    settings = {
      type = format.type;
      default = null;
      description = "Settings for KeaDHCP DNS";
      example = {
        ip-address = "127.0.0.1";
        port = 53001;
        dns-server-timeout = 100;
        ncr-protocol = "UDP";
        ncr-format = "JSON";
        tsig-keys = [ ];
        forward-ddns = {
          ddns-domains = [ ];
        };
        reverse-ddns = {
          ddns-domains = [ ];
        };
      };
    };
  };

  config = {
    configData."dhcp-ddns.conf" = lib.generators.toINI { } cfg.settings;
    process = {
      argv = [ (lib.getExe' cfg.package "kea-dhcp-ddns") ];
      flags = {
        "c" = config.configData."dhcp-ddns.conf".path;
      };

      flagFormat = name: {
        option = "-${name}";
      };
    };
  }
  // lib.optionalAttrs (options ? systemd) {
    systemd.service = {
      description = "Kea DHCP-DDNS Server";
      documentation = [
        "man:kea-dhcp-ddns(8)"
        "https://kea.readthedocs.io/en/kea-${cfg.package.version}/arm/ddns.html"
      ];

      serviceConfig = {
        Restart = "on-failure";
        DymanicUser = true;
        AmbientCapabilities = [ "CAP_NET_ADMIN" ];
        CapabilityBoundingSet = [ "CAP_NET_ADMIN" ];
      };
    };
  };

  meta.maintainers = [ lib.maintainers.eveeifyeve ];
}
