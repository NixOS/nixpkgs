{
  lib,
  config,
  ...
}:
let
  cfg = config.services.matter-server;
  storageDir = "matter-server";
in

{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "matter-server" "package" ]
      "This module now configures matterjs-server with matter-server compatible options. Please configure services.matterjs-server.package instead."
    )
    (lib.mkRemovedOptionModule [ "services" "matter-server" "extraArgs" ]
      "This module now configures matterjs-server with matter-server compatible options. Please configure services.matterjs-server.extraArgs instead."
    )
  ];

  meta.maintainers = with lib.maintainers; [ leonm1 ];

  options.services.matter-server = {
    enable = lib.mkEnableOption "matterjs-server (matter-server compatibility module)";

    port = lib.mkOption {
      type = lib.types.port;
      default = 5580;
      description = "Port to expose the matter-server service on.";
    };

    vendorId = lib.mkOption {
      type = lib.types.int;
      default = 4939; # home-assistant vendor ID
      description = "Vendor ID to expose to the matter network.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the port in the firewall.";
    };

    logLevel = lib.mkOption {
      type = lib.types.enum [
        "critical"
        "error"
        "warning"
        "info"
        "debug"
      ];
      default = "info";
      description = "Verbosity of logs from the matter-server";
    };
  };

  config = lib.mkIf cfg.enable {
    services.matterjs-server = {
      enable = cfg.enable;
      port = cfg.port;
      openFirewall = cfg.openFirewall;

      # Patch the matterjs-server service to use existing users' config, which
      # matterjs-server will migrate automatically.
      stateDirectoryName = storageDir;
      extraArgs = [
        "--vendorid=${toString cfg.vendorId}"
        "--log-level=${cfg.logLevel}"
      ];
    };

    systemd.services.matterjs-server.aliases = [ "matter-server.service" ];
  };
}
