{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.zinc;
in
{
  options.services.zinc = {
    enable = mkEnableOption (lib.mdDoc "Whether to enable ZincSearch.");

    package = mkOption {
      type = types.package;
      description = lib.mdDoc "ZincSearch package to use.";
      default = pkgs.zinc;
      defaultText = literalExpression "pkgs.zinc";
    };

    firstAdminUsername = mkOption {
      type = types.str;
      description = lib.mdDoc "Username for first ZincSearch admin user";
      default = "admin";
    };

    firstAdminPasswordFile = mkOption {
      type = types.path;
      description = lib.mdDoc "Password file for first ZincSearch admin user";
    };

    port = mkOption {
      type = types.int;
      description = lib.mdDoc "Network port to listen for HTTP traffic.";
      default = 4080;
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "Open ports in the firewall for ZincSearch.";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.zinc = {
      description = "ZincSearch Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = {
        ZINC_FIRST_ADMIN_USER = cfg.firstAdminUsername;
        ZINC_SERVER_PORT = toString cfg.port;
        ZINC_PROMETHEUS_ENABLE = "true";

        # recommended setting for production operation of the Gin web framework
        # https://github.com/zinclabs/zinc/blob/16ccff60aa361421e0075e44e47142986cedebe1/pkg/config/config.go#L121
        GIN_MODE = "release";
      };

      script = ''
        export ZINC_DATA_PATH=$STATE_DIRECTORY
        export ZINC_FIRST_ADMIN_PASSWORD="$(head -n1 ${escapeShellArg cfg.firstAdminPasswordFile})"
        if [[ $ZINC_FIRST_ADMIN_PASSWORD == "" ]]; then
          echo "ZINC_FIRST_ADMIN_PASSWORD is unset; check that the NixOS firstAdminPasswordFile option is not blank or empty"
          exit 1
        fi
        ${cfg.package}/bin/zinc
      '';

      serviceConfig = {
        User = "zinc";
        Group = "zinc";
        StateDirectory = "zinc";

        # hardening options
        NoNewPrivileges = "yes";
        PrivateTmp = "yes";
        PrivateDevices = "yes";
        DevicePolicy = "closed";
        ProtectSystem = "strict";
        ProtectHome = "read-only";
        ProtectControlGroups = "yes";
        ProtectKernelModules = "yes";
        ProtectKernelTunables = "yes";
        RestrictAddressFamilies = "AF_INET AF_INET6";
        RestrictNamespaces = "yes";
        RestrictRealtime = "yes";
        RestrictSUIDSGID = "yes";
        MemoryDenyWriteExecute = "yes";
        LockPersonality = "yes";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    environment.systemPackages = [ cfg.package ];

    users.groups.zinc = {};
    users.users.zinc = {
      description = "ZincSearch daemon user";
      group = "zinc";
      isSystemUser = true;
    };
  };
}
