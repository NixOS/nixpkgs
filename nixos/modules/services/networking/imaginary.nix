{ lib, config, pkgs, utils, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.services.imaginary;
in {
  options.services.imaginary = {
    enable = mkEnableOption "imaginary image processing microservice";

    address = mkOption {
      type = types.str;
      default = "localhost";
      description = ''
        Bind address. Corresponds to the `-a` flag.
        Set to `""` to bind to all addresses.
      '';
      example = "[::1]";
    };

    port = mkOption {
      type = types.port;
      default = 8088;
      description = "Bind port. Corresponds to the `-p` flag.";
    };

    settings = mkOption {
      description = ''
        Command line arguments passed to the imaginary executable, stripped of
        the prefix `-`. See upstream's
        [README](https://github.com/h2non/imaginary#command-line-usage) for all
        options.
      '';
      type = types.submodule {
        freeformType = with types; attrsOf (oneOf [
          bool
          int
          (nonEmptyListOf str)
          str
        ]);

        options = {
          return-size = mkOption {
            type = types.bool;
            default = false;
            description = "Return the image size in the HTTP headers.";
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [ {
      assertion = ! lib.hasAttr "a" cfg.settings;
      message = "Use services.imaginary.address to specify the -a flag.";
    } {
      assertion = ! lib.hasAttr "p" cfg.settings;
      message = "Use services.imaginary.port to specify the -p flag.";
    } ];

    systemd.services.imaginary = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = rec {
        ExecStart = let
          args = lib.mapAttrsToList (key: val:
            "-" + key + "=" + lib.concatStringsSep "," (map toString (lib.toList val))
          ) (cfg.settings // { a = cfg.address; p = cfg.port; });
        in "${pkgs.imaginary}/bin/imaginary ${utils.escapeSystemdExecArgs args}";
        ProtectProc = "invisible";
        BindReadOnlyPaths = lib.optional (cfg.settings ? mount) cfg.settings.mount;
        CapabilityBoundingSet = if cfg.port < 1024 then
          [ "CAP_NET_BIND_SERVICE" ]
        else
          [ "" ];
        AmbientCapabilities = CapabilityBoundingSet;
        NoNewPrivileges = true;
        DynamicUser = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        TemporaryFileSystem = [ "/:ro" ];
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateUsers = cfg.port >= 1024;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        PrivateMounts = true;
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        DevicePolicy = "closed";
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
