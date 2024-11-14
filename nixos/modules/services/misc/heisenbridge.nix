{ config, pkgs, lib, ... }:
let
  cfg = config.services.heisenbridge;

  pkg = config.services.heisenbridge.package;
  bin = "${pkg}/bin/heisenbridge";

  jsonType = (pkgs.formats.json { }).type;

  registrationFile = "/var/lib/heisenbridge/registration.yml";
  # JSON is a proper subset of YAML
  bridgeConfig = builtins.toFile "heisenbridge-registration.yml" (builtins.toJSON {
    id = "heisenbridge";
    url = cfg.registrationUrl;
    # Don't specify as_token and hs_token
    rate_limited = false;
    sender_localpart = "heisenbridge";
    namespaces = cfg.namespaces;
  });
in
{
  options.services.heisenbridge = {
    enable = lib.mkEnableOption "the Matrix to IRC bridge";

    package = lib.mkPackageOption pkgs "heisenbridge" { };

    homeserver = lib.mkOption {
      type = lib.types.str;
      description = "The URL to the home server for client-server API calls";
      example = "http://localhost:8008";
    };

    registrationUrl = lib.mkOption {
      type = lib.types.str;
      description = ''
        The URL where the application service is listening for HS requests, from the Matrix HS perspective.#
        The default value assumes the bridge runs on the same host as the home server, in the same network.
      '';
      example = "https://matrix.example.org";
      default = "http://${cfg.address}:${toString cfg.port}";
      defaultText = "http://$${cfg.address}:$${toString cfg.port}";
    };

    address = lib.mkOption {
      type = lib.types.str;
      description = "Address to listen on. IPv6 does not seem to be supported.";
      default = "127.0.0.1";
      example = "0.0.0.0";
    };

    port = lib.mkOption {
      type = lib.types.port;
      description = "The port to listen on";
      default = 9898;
    };

    debug = lib.mkOption {
      type = lib.types.bool;
      description = "More verbose logging. Recommended during initial setup.";
      default = false;
    };

    owner = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = ''
        Set owner MXID otherwise first talking local user will claim the bridge
      '';
      default = null;
      example = "@admin:example.org";
    };

    namespaces = lib.mkOption {
      description = "Configure the 'namespaces' section of the registration.yml for the bridge and the server";
      # TODO link to Matrix documentation of the format
      type = lib.types.submodule {
        freeformType = jsonType;
      };

      default = {
        users = [
          {
            regex = "@irc_.*";
            exclusive = true;
          }
        ];
        aliases = [ ];
        rooms = [ ];
      };
    };

    identd.enable = lib.mkEnableOption "identd service support";
    identd.port = lib.mkOption {
      type = lib.types.port;
      description = "identd listen port";
      default = 113;
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Heisenbridge is configured over the command line. Append extra arguments here";
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.heisenbridge = {
      description = "Matrix<->IRC bridge";
      before = [ "matrix-synapse.service" ]; # So the registration file can be used by Synapse
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        umask 077
        set -e -u -o pipefail

        if ! [ -f "${registrationFile}" ]; then
          # Generate registration file if not present (actually, we only care about the tokens in it)
          ${bin} --generate --config ${registrationFile}
        fi

        # Overwrite the registration file with our generated one (the config may have changed since then),
        # but keep the tokens. Two step procedure to be failure safe
        ${pkgs.yq}/bin/yq --slurp \
          '.[0] + (.[1] | {as_token, hs_token})' \
          ${bridgeConfig} \
          ${registrationFile} \
          > ${registrationFile}.new
        mv -f ${registrationFile}.new ${registrationFile}

        # Grant Synapse access to the registration
        if ${pkgs.getent}/bin/getent group matrix-synapse > /dev/null; then
          chgrp -v matrix-synapse ${registrationFile}
          chmod -v g+r ${registrationFile}
        fi
      '';

      serviceConfig = rec {
        Type = "simple";
        ExecStart = lib.concatStringsSep " " (
          [
            bin
            (if cfg.debug then "-vvv" else "-v")
            "--config"
            registrationFile
            "--listen-address"
            (lib.escapeShellArg cfg.address)
            "--listen-port"
            (toString cfg.port)
          ]
          ++ (lib.optionals (cfg.owner != null) [
            "--owner"
            (lib.escapeShellArg cfg.owner)
          ])
          ++ (lib.optionals cfg.identd.enable [
            "--identd"
            "--identd-port"
            (toString cfg.identd.port)
          ])
          ++ [
            (lib.escapeShellArg cfg.homeserver)
          ]
          ++ (map (lib.escapeShellArg) cfg.extraArgs)
        );

        # Hardening options

        User = "heisenbridge";
        Group = "heisenbridge";
        RuntimeDirectory = "heisenbridge";
        RuntimeDirectoryMode = "0700";
        StateDirectory = "heisenbridge";
        StateDirectoryMode = "0755";

        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        RestrictSUIDSGID = true;
        PrivateMounts = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        RestrictNamespaces = true;
        RemoveIPC = true;
        UMask = "0077";

        CapabilityBoundingSet = [ "CAP_CHOWN" ] ++ lib.optional (cfg.port < 1024 || (cfg.identd.enable && cfg.identd.port < 1024)) "CAP_NET_BIND_SERVICE";
        AmbientCapabilities = CapabilityBoundingSet;
        NoNewPrivileges = true;
        LockPersonality = true;
        RestrictRealtime = true;
        SystemCallFilter = ["@system-service" "~@privileged" "@chown"];
        SystemCallArchitectures = "native";
        RestrictAddressFamilies = "AF_INET AF_INET6";
      };
    };

    users.groups.heisenbridge = {};
    users.users.heisenbridge = {
      description = "Service user for the Heisenbridge";
      group = "heisenbridge";
      isSystemUser = true;
    };
  };

  meta.maintainers = [ ];
}
