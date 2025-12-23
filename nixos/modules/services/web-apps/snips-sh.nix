{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    mkEnableOption
    mkPackageOption
    mapAttrs
    optional
    boolToString
    isBool
    mkIf
    getExe
    types
    ;

  cfg = config.services.snips-sh;
in
{
  meta.maintainers = with lib.maintainers; [
    isabelroses
    NotAShelf
  ];

  options.services.snips-sh = {
    enable = mkEnableOption "snips.sh";

    package = mkPackageOption pkgs "snips-sh" {
      example = "pkgs.snips-sh.override {withTensorflow = true;}";
    };

    stateDir = mkOption {
      type = types.path;
      default = "/var/lib/snips-sh";
      description = "The state directory of the service.";
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = types.attrsOf (
          types.nullOr (
            types.oneOf [
              types.str
              types.int
              types.bool
            ]
          )
        );

        options = {
          SNIPS_HTTP_INTERNAL = mkOption {
            type = types.str;
            description = "The internal HTTP address of the service";
          };

          SNIPS_SSH_INTERNAL = mkOption {
            type = types.str;
            description = "The internal SSH address of the service";
          };
        };
      };

      default = { };
      example = {
        SNIPS_HTTP_INTERNAL = "http://0.0.0.0:8080";
        SNIPS_SSH_INTERNAL = "ssh://0.0.0.0:2222";
      };

      description = ''
        The configuration of snips-sh is done through environment variables,
        therefore you must use upper snake case (e.g. {env}`SNIPS_HTTP_INTERNAL`).

        Based on the attributes passed to this config option an environment file will be generated
        that is passed to snips-sh's systemd service.

        The available configuration options can be found in
        [self-hosting guide](https://github.com/robherley/snips.sh/blob/main/docs/self-hosting.md#configuration) to
        find about the environment variables you can use.
      '';
    };

    environmentFile = mkOption {
      type = with types; nullOr path;
      default = null;
      example = "/etc/snips-sh.env";
      description = ''
        Additional environment file as defined in {manpage}`systemd.exec(5)`.

        Sensitive secrets such as {env}`SNIPS_SSH_HOSTKEYPATH` and {env}`SNIPS_METRICS_STATSD`
        may be passed to the service while avoiding potentially making them world-readable in the nix store or
        to convert an existing non-nix installation with minimum hassle.

        Note that this file needs to be available on the host on which
        `snips-sh` is running.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd = {
      tmpfiles.settings."10-snips-sh" = {
        "${cfg.stateDir}/data".D = {
          mode = "0755";
        };
      };

      services.snips-sh = {
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];

        environment = mapAttrs (_: v: if isBool v then boolToString v else toString v) cfg.settings;

        serviceConfig = {
          EnvironmentFile = optional (cfg.environmentFile != null) cfg.environmentFile;
          ExecStart = getExe cfg.package;
          LimitNOFILE = "1048576";
          AmbientCapabilities = "CAP_NET_BIND_SERVICE";
          WorkingDirectory = cfg.stateDir;
          RuntimeDirectory = "snips-sh";
          StateDirectory = "snips-sh";
          StateDirectoryMode = "0700";
          Restart = "always";

          # hardening
          DynamicUser = true;
          NoNewPrivileges = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          ProtectHostname = true;
          ProtectClock = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectControlGroups = true;
          PrivateTmp = true;
          PrivateDevices = true;
          PrivateUsers = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          RestrictNamespaces = true;
          RestrictSUIDSGID = true;
          SystemCallFilter = "@system-service";
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
          RemoveIPC = true;
        };
      };
    };
  };
}
