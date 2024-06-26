{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.trust-dns;
  toml = pkgs.formats.toml { };

  configFile = toml.generate "trust-dns.toml" (
    lib.filterAttrsRecursive (_: v: v != null) cfg.settings
  );

  zoneType = lib.types.submodule (
    { config, ... }:
    {
      options = with lib; {
        zone = mkOption {
          type = types.str;
          description = ''
            Zone name, like "example.com", "localhost", or "0.0.127.in-addr.arpa".
          '';
        };
        zone_type = mkOption {
          type = types.enum [
            "Primary"
            "Secondary"
            "Hint"
            "Forward"
          ];
          default = "Primary";
          description = ''
            One of:
            - "Primary" (the master, authority for the zone).
            - "Secondary" (the slave, replicated from the primary).
            - "Hint" (a cached zone with recursive resolver abilities).
            - "Forward" (a cached zone where all requests are forwarded to another resolver).

            For more details about these zone types, consult the documentation for BIND,
            though note that trust-dns supports only a subset of BIND's zone types:
            <https://bind9.readthedocs.io/en/v9_18_4/reference.html#type>
          '';
        };
        file = mkOption {
          type = types.either types.path types.str;
          default = "${config.zone}.zone";
          defaultText = literalExpression ''"''${config.zone}.zone"'';
          description = ''
            Path to the .zone file.
            If not fully-qualified, this path will be interpreted relative to the `directory` option.
            If omitted, defaults to the value of the `zone` option suffixed with ".zone".
          '';
        };
      };
    }
  );
in
{
  meta.maintainers = with lib.maintainers; [ colinsane ];
  options = {
    services.trust-dns = with lib; {
      enable = mkEnableOption "trust-dns";
      package = mkPackageOption pkgs "trust-dns" {
        extraDescription = ''
          ::: {.note}
          The package must provide `meta.mainProgram` which names the server binary; any other utilities (client, resolver) are not needed.
          :::
        '';
      };
      quiet = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Log ERROR level messages only.
          This option is mutually exclusive with the `debug` option.
          If neither `quiet` nor `debug` are enabled, logging defaults to the INFO level.
        '';
      };
      debug = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Log DEBUG, INFO, WARN and ERROR messages.
          This option is mutually exclusive with the `debug` option.
          If neither `quiet` nor `debug` are enabled, logging defaults to the INFO level.
        '';
      };
      settings = mkOption {
        description = ''
          Settings for trust-dns. The options enumerated here are not exhaustive.
          Refer to upstream documentation for all available options:
          - [Example settings](https://github.com/bluejekyll/trust-dns/blob/main/tests/test-data/test_configs/example.toml)
        '';
        type = types.submodule {
          freeformType = toml.type;
          options = {
            listen_addrs_ipv4 = mkOption {
              type = types.listOf types.str;
              default = [ "0.0.0.0" ];
              description = ''
                List of ipv4 addresses on which to listen for DNS queries.
              '';
            };
            listen_addrs_ipv6 = mkOption {
              type = types.listOf types.str;
              default = lib.optional config.networking.enableIPv6 "::0";
              defaultText = literalExpression ''lib.optional config.networking.enableIPv6 "::0"'';
              description = ''
                List of ipv6 addresses on which to listen for DNS queries.
              '';
            };
            listen_port = mkOption {
              type = types.port;
              default = 53;
              description = ''
                Port to listen on (applies to all listen addresses).
              '';
            };
            directory = mkOption {
              type = types.str;
              default = "/var/lib/trust-dns";
              description = ''
                The directory in which trust-dns should look for .zone files,
                whenever zones aren't specified by absolute path.
              '';
            };
            zones = mkOption {
              description = "List of zones to serve.";
              default = [ ];
              type = types.listOf (types.coercedTo types.str (zone: { inherit zone; }) zoneType);
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.trust-dns = {
      description = "trust-dns Domain Name Server";
      unitConfig.Documentation = "https://trust-dns.org/";
      serviceConfig = {
        ExecStart =
          let
            flags = (lib.optional cfg.debug "--debug") ++ (lib.optional cfg.quiet "--quiet");
            flagsStr = builtins.concatStringsSep " " flags;
          in
          ''
            ${cfg.package}/bin/${cfg.package.meta.mainProgram} --config ${configFile} ${flagsStr}
          '';
        Type = "simple";
        Restart = "on-failure";
        RestartSec = "10s";
        DynamicUser = true;

        StateDirectory = "trust-dns";
        ReadWritePaths = [ cfg.settings.directory ];

        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "full";
        RemoveIPC = true;
        RestrictAddressFamilies = [ "AF_INET AF_INET6" ];
        RestrictNamespaces = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
      };
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
