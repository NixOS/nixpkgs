{
  lib,
  config,
  ...
}:
let
  cfg = config.services.matter-server;
  mjs-cfg = config.services.matterjs-server;
  storageDir = "matter-server";
  storagePath = "/var/lib/${storageDir}";
  vendorId = "4939"; # home-assistant vendor ID
in

{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "matter-server" "package" ]
      "This module now configures matterjs-server with matter-server compatible options. Please configure services.matterjs-server.package instead."
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

    extraArgs = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = ''
        Attribute set of extra arguments to pass to the matter-server executable.
        See <https://github.com/home-assistant-libs/python-matter-server?tab=readme-ov-file#running-the-development-server> for options.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.matterjs-server = {
      enable = cfg.enable;
      port = cfg.port;
      openFirewall = cfg.openFirewall;
    };

    # Patch the matterjs-server service to use existing users' config, which
    # matterjs-server will migrate automatically.
    systemd.services.matterjs-server.serviceConfig = {
      StateDirectory = lib.mkForce storageDir;

      ExecStart = lib.mkForce ''
        "${lib.getExe mjs-cfg.package}" ${
          lib.concatStringsSep " " (
            (lib.cli.toCommandLineGNU { } (
              {
                port = mjs-cfg.port;
                listen-address = mjs-cfg.listenAddress;
                vendorid = vendorId;
                storage-path = storagePath;
                log-level = cfg.logLevel;
                production-mode = true;
              }
              // cfg.extraArgs
            ))
          ++ mjs-cfg.extraArgs)
        }
      '';
    };
  };
}
