{ config
, lib
, pkgs
, options
}:

with lib;

let
  cfg = config.services.prometheus.exporters.kea;
in {
  port = 9547;
  extraOpts = {
    controlSocketPaths = mkOption {
      type = types.listOf types.str;
      example = literalExpression ''
        [
          "/run/kea/kea-dhcp4.socket"
          "/run/kea/kea-dhcp6.socket"
        ]
      '';
      description = lib.mdDoc ''
        Paths to kea control sockets
      '';
    };
  };
  serviceOpts = {
    after = [
      "kea-dhcp4-server.service"
      "kea-dhcp6-server.service"
    ];
    serviceConfig = {
      User = "kea";
      ExecStart = ''
        ${pkgs.prometheus-kea-exporter}/bin/kea-exporter \
          --address ${cfg.listenAddress} \
          --port ${toString cfg.port} \
          ${concatStringsSep " \\n" cfg.controlSocketPaths}
      '';
      SupplementaryGroups = [ "kea" ];
      RestrictAddressFamilies = [
        # Need AF_UNIX to collect data
        "AF_UNIX"
      ];
    };
  };
}
