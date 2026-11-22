{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.services.prometheus.exporters.kea;
  inherit (lib)
    mkOption
    types
    mkRenamedOptionModule
    literalExpression
    ;
in
{
  imports = [
    (mkRenamedOptionModule [ "controlSocketPaths" ] [ "targets" ])
  ];
  port = 9547;
  extraOpts = {
    targets = mkOption {
      type = types.listOf types.str;
      example = literalExpression ''
        [
          "/run/kea/kea-dhcp4.socket"
          "/run/kea/kea-dhcp6.socket"
          "http://127.0.0.1:8547"
        ]
      '';
      description = ''
        Paths or URLs to the Kea control socket.
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
      DynamicUser = true;
      ExecStart = utils.escapeSystemdExecArgs (
        [
          (lib.getExe pkgs.prometheus-kea-exporter)
          "--address"
          cfg.listenAddress
          "--port"
          cfg.port
        ]
        ++ cfg.extraFlags
        ++ cfg.targets
      );
      RuntimeDirectory = "kea";
      RuntimeDirectoryPreserve = true;
      RestrictAddressFamilies = [
        # Need AF_UNIX to collect data
        "AF_UNIX"
      ];
    };
  };
}
