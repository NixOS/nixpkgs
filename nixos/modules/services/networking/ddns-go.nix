{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.ddns-go;
  settingsFormat = pkgs.formats.yaml { };

  bindPrivileged = cfg.port < 1024;

  # Generate merged ddns-go config with secrets.
  gen-ddns-go-config = pkgs.writeShellApplication {
    name = "gen-ddns-go-config";
    runtimeInputs = with pkgs; [ yq-go ];
    text =
      utils.genJqSecretsReplacementSnippet cfg.settings "/run/ddns-go/new"
      # Merge existing config with new settings, overriding existing values with new ones
      + lib.optionalString cfg.mutableConfig ''
        if [ -f /etc/ddns-go/config.yaml ]; then

        yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' \
        /etc/ddns-go/config.yaml /run/ddns-go/new > /run/ddns-go/tmp

        [ -f /run/ddns-go/tmp ] && mv /run/ddns-go/tmp /run/ddns-go/new

        fi
      ''
      # Finalize the configuration update by replacing the existing config file.
      + ''
        mv /run/ddns-go/new /etc/ddns-go/config.yaml
        chown --reference=/etc/ddns-go /etc/ddns-go/config.yaml
      '';
  };
in
{
  meta.maintainers = with lib.maintainers; [ moraxyc ];

  options = {
    services.ddns-go = {
      enable = lib.mkEnableOption "Simple and easy to use DDNS";

      package = lib.mkPackageOption pkgs "ddns-go" { };

      mutableConfig = lib.mkOption {
        type = lib.types.bool;
        # The web interface is the primary configuration method recommended by the upstream.
        default = true;
        description = "Allow ddns-go to persist settings in the config file.";
      };

      extraFlags = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "-noweb" ];
        description = ''
          Extra flags passed to the ddns-go command.
        '';
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        description = ''
          Address for the web server to listen on.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 9876;
        description = ''
          Port for the web server to listen on.
        '';
      };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = settingsFormat.type;
        };
        default = { };
        description = ''
          The ddns-go configuration, see <https://github.com/jeessy2/ddns-go#readme>
          for possible options.

          Options containing secret data should be set as an attribute set
          with the `_secret` attribute. This should be a string or a structured
          JSON with `quote = false;`, pointing to a file that contains the value.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.ddns-go = {
      description = "ddns-go dynamic DNS service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        # genJqSecretsReplacementSnippet may need to access files outside ReadWritePaths.
        ExecStartPre = "+${lib.getExe gen-ddns-go-config}";
        ExecStart =
          "${lib.getExe cfg.package} "
          + lib.escapeShellArgs (
            [
              "-c"
              "/etc/ddns-go/config.yaml"
              "-l"
              "${cfg.host}:${toString cfg.port}"
            ]
            ++ cfg.extraFlags
          );
        Type = "simple";
        Restart = "on-failure";
        RuntimeDirectory = "ddns-go";
        ConfigurationDirectory = "ddns-go";

        # Hardening
        ReadWritePaths = [ "/etc/ddns-go" ];
        User = "ddns-go";
        Group = "ddns-go";
        DynamicUser = true;
        DeviceAllow = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
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
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        UMask = "0077";
        RestrictNamespaces = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        # Must disable PrivateUsers when binding to privileged ports (<1024)
        PrivateUsers = !bindPrivileged;
        AmbientCapabilities = lib.optionalString bindPrivileged "CAP_NET_BIND_SERVICE";
        CapabilityBoundingSet = lib.optionalString bindPrivileged "CAP_NET_BIND_SERVICE";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged @resources"
        ];
      };
    };
  };
}
