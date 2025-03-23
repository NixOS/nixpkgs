{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.matrix-conduit;

  format = pkgs.formats.toml { };
  configFile = format.generate "conduit.toml" cfg.settings;
in
{
  meta.maintainers = with lib.maintainers; [ pstn ];
  options.services.matrix-conduit = {
    enable = lib.mkEnableOption "matrix-conduit";

    extraEnvironment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = "Extra Environment variables to pass to the conduit server.";
      default = { };
      example = {
        RUST_BACKTRACE = "yes";
      };
    };

    package = lib.mkPackageOption pkgs "matrix-conduit" { };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;
        options = {
          global.server_name = lib.mkOption {
            type = lib.types.str;
            example = "example.com";
            description = "The server_name is the name of this server. It is used as a suffix for user # and room ids.";
          };
          global.port = lib.mkOption {
            type = lib.types.port;
            default = 6167;
            description = "The port Conduit will be running on. You need to set up a reverse proxy in your web server (e.g. apache or nginx), so all requests to /_matrix on port 443 and 8448 will be forwarded to the Conduit instance running on this port";
          };
          global.max_request_size = lib.mkOption {
            type = lib.types.ints.positive;
            default = 20000000;
            description = "Max request size in bytes. Don't forget to also change it in the proxy.";
          };
          global.allow_registration = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether new users can register on this server.";
          };
          global.allow_encryption = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether new encrypted rooms can be created. Note: existing rooms will continue to work.";
          };
          global.allow_federation = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = ''
              Whether this server federates with other servers.
            '';
          };
          global.trusted_servers = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ "matrix.org" ];
            description = "Servers trusted with signing server keys.";
          };
          global.address = lib.mkOption {
            type = lib.types.str;
            default = "::1";
            description = "Address to listen on for connections by the reverse proxy/tls terminator.";
          };
          global.database_path = lib.mkOption {
            type = lib.types.str;
            default = "/var/lib/matrix-conduit/";
            readOnly = true;
            description = ''
              Path to the conduit database, the directory where conduit will save its data.
              Note that due to using the DynamicUser feature of systemd, this value should not be changed
              and is set to be read only.
            '';
          };
          global.database_backend = lib.mkOption {
            type = lib.types.enum [
              "sqlite"
              "rocksdb"
            ];
            default = "sqlite";
            example = "rocksdb";
            description = ''
              The database backend for the service. Switching it on an existing
              instance will require manual migration of data.
            '';
          };
          global.allow_check_for_updates = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
              Whether to allow Conduit to automatically contact
              <https://conduit.rs> hourly to check for important Conduit news.

              Disabled by default because nixpkgs handles updates.
            '';
          };
        };
      };
      default = { };
      description = ''
        Generates the conduit.toml configuration file. Refer to
        <https://docs.conduit.rs/configuration.html>
        for details on supported values.
        Note that database_path can not be edited because the service's reliance on systemd StateDir.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.conduit = {
      description = "Conduit Matrix Server";
      documentation = [ "https://gitlab.com/famedly/conduit/" ];
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      environment = lib.mkMerge ([
        { CONDUIT_CONFIG = configFile; }
        cfg.extraEnvironment
      ]);
      serviceConfig = {
        DynamicUser = true;
        User = "conduit";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateUsers = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        StateDirectory = "matrix-conduit";
        StateDirectoryMode = "0700";
        ExecStart = "${cfg.package}/bin/conduit";
        Restart = "on-failure";
        RestartSec = 10;
        StartLimitBurst = 5;
        UMask = "077";
      };
    };
  };
}
