{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.chhoto-url;

  environment = lib.mapAttrs (
    _: value:
    if value == true then
      "True"
    else if value == false then
      "False"
    else
      toString value
  ) cfg.settings;
in

{
  meta.maintainers = with lib.maintainers; [ defelo ];

  options.services.chhoto-url = {
    enable = lib.mkEnableOption "Chhoto URL";

    package = lib.mkPackageOption pkgs "chhoto-url" { };

    settings = lib.mkOption {
      description = ''
        Configuration of Chhoto URL.
        See <https://github.com/SinTan1729/chhoto-url/blob/main/compose.yaml> for a list of options.
      '';
      example = {
        port = 4567;
      };

      type = lib.types.submodule {
        freeformType =
          with lib.types;
          attrsOf (oneOf [
            str
            int
            bool
          ]);

        options = {
          db_url = lib.mkOption {
            type = lib.types.path;
            description = "The path of the sqlite database.";
            default = "/var/lib/chhoto-url/urls.sqlite";
          };

          port = lib.mkOption {
            type = lib.types.port;
            description = "The port to listen on.";
            example = 4567;
          };

          cache_control_header = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            description = "The Cache-Control header to send.";
            default = null;
            example = "no-cache, private";
          };

          disable_frontend = lib.mkOption {
            type = lib.types.bool;
            description = "Whether to disable the frontend.";
            default = false;
          };

          public_mode = lib.mkOption {
            type = lib.types.bool;
            description = "Whether to enable public mode.";
            default = false;
            apply = x: if x then "Enable" else "Disable";
          };

          public_mode_expiry_delay = lib.mkOption {
            type = lib.types.nullOr lib.types.ints.unsigned;
            description = "The maximum expiry delay in seconds to force in public mode.";
            default = null;
            example = 3600;
          };

          redirect_method = lib.mkOption {
            type = lib.types.enum [
              "TEMPORARY"
              "PERMANENT"
            ];
            description = "The redirect method to use.";
            default = "PERMANENT";
          };

          hash_algorithm = lib.mkOption {
            type = lib.types.nullOr (lib.types.enum [ "Argon2" ]);
            description = ''
              The hash algorithm to use for passwords and API keys.
              Set to `null` if you want to provide these secrets as plaintext.
            '';
            default = null;
          };

          site_url = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            description = "The URL under which Chhoto URL is externally reachable.";
            default = null;
          };

          slug_style = lib.mkOption {
            type = lib.types.enum [
              "Pair"
              "UID"
            ];
            description = "The slug style to use for auto-generated URLs.";
            default = "Pair";
          };

          slug_length = lib.mkOption {
            type = lib.types.addCheck lib.types.int (x: x >= 4);
            description = "The length of auto-generated slugs.";
            default = 8;
          };

          try_longer_slugs = lib.mkOption {
            type = lib.types.bool;
            description = "Whether to try a longer UID upon collision.";
            default = false;
          };

          allow_capital_letters = lib.mkOption {
            type = lib.types.bool;
            description = "Whether to allow capital letters in slugs.";
            default = false;
          };

          custom_landing_directory = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            description = "The path of a directory which contains a custom landing page.";
            default = null;
          };
        };
      };
    };

    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      example = [ "/run/secrets/chhoto-url.env" ];
      description = ''
        Files to load environment variables from in addition to [](#opt-services.chhoto-url.settings).
        This is useful to avoid putting secrets into the nix store.
        See <https://github.com/SinTan1729/chhoto-url/blob/main/compose.yaml> for a list of options.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.chhoto-url = {
      wantedBy = [ "multi-user.target" ];

      inherit environment;

      serviceConfig = {
        User = "chhoto-url";
        Group = "chhoto-url";
        DynamicUser = true;
        StateDirectory = "chhoto-url";
        EnvironmentFile = cfg.environmentFiles;

        ExecStart = lib.getExe cfg.package;

        # hardening
        AmbientCapabilities = "";
        CapabilityBoundingSet = [ "" ];
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [ "AF_INET AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SocketBindAllow = "tcp:${toString cfg.settings.port}";
        SocketBindDeny = "any";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0077";
      };
    };
  };
}
