{ formats }:
{
  config,
  lib,
  options,
  ...
}:
let
  cfg = config.services.kea-dhcp;
  format = formats.json { };
in
{
  options.kea-dhcp = {
    package = lib.mkOption {
      type = lib.types.package;
      description = "The package you want to use.";
    };

    type = lib.mkOption {
      type = lib.types.enum [
        "dhcp4"
        "dhcp6"
      ];
    };

    settings = {
      type = format.type;
      default = null;
      description = "Settings for KeaDHCP";
      example = {
        valid-lifetime = 4000;
        renew-timer = 1000;
        rebind-timer = 2000;
        preferred-lifetime = 3000;
        interfaces-config = {
          interfaces = [
            "eth0"
          ];
        };
        lease-database = {
          type = "memfile";
          persist = true;
          name = "/var/lib/kea/dhcp6.leases";
        };
        subnet6 = [
          {
            id = 1;
            subnet = "2001:db8:1::/64";
            pools = [
              {
                pool = "2001:db8:1::1-2001:db8:1::ffff";
              }
            ];
          }
        ];
      };
    };
  };

  config = {
    configData."${cfg.type}-server.conf" = lib.generators.toINI { } cfg.settings;
    process = {
      argv =
        lib.optional (cfg.type == "dhcp4") "kea-dhcp4" ++ lib.optional (cfg.type == "dhcp6") "kea-ghcp6";
      flags = {
        "c" = config.configData."${cfg.type}-server.conf".path;
      };

      flagFormat = name: {
        option = "-${name}";
      };
    };
  }
  // lib.optionalAttrs (options ? systemd) {
    systemd.service = {
      description =
        lib.optionalString (cfg.type == "dhcp4") "Kea DHCP4 Server"
        ++ lib.optionalString (cfg.type == "dhcp6") "Kea DHCP6 Server";
      documentation =
        if (cfg.type == "dhcp4") then
          [
            "man:kea-dhcp4(8)"
            "https://kea.readthedocs.io/en/kea-${cfg.package.version}/arm/dhcp4-srv.html"
          ]
        else if lib.optional (cfg.type == "dhcp6") then
          [
            "man:kea-dhcp6(8)"
            "https://kea.readthedocs.io/en/kea-${cfg.package.version}/arm/dhcp6-srv.html"
          ]
        else
          [ ];

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
