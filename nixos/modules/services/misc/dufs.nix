{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.dufs;
  types = lib.types;
in
{
  options.services.dufs = {
    enable = lib.mkEnableOption "the dufs server";
    package = lib.mkPackageOption pkgs "dufs" { };
    settings = lib.mkOption {
      type = types.submodule {
        options = {
          serve-path = lib.mkOption {
            type = types.path;
            description = "Specific path to serve.";
          };
          bind = lib.mkOption {
            type = types.nullOr types.str;
            description = "Specify bind address or unix socket.";
            default = null;
          };
          port = lib.mkOption {
            type = types.port;
            description = "Specify port to listen on.";
            default = 5000;
          };
          path-prefix = lib.mkOption {
            type = types.nullOr types.path;
            description = "Specify a path prefix.";
            default = null;
          };
          hidden = lib.mkOption {
            type = types.listOf types.str;
            description = "Hide paths from directory listings, e.g. tmp,*.log,*.lock.";
            default = [ ];
            example = lib.literalExpression ''
              [
                "tmp"
                "*.log"
                "*.lock."
              ]
            '';
          };
          allow-all = lib.mkOption {
            type = types.bool;
            description = "Allow all operations.";
            default = true;
          };
          allow-upload = lib.mkOption {
            type = types.bool;
            description = "Allow upload files/folders.";
            default = false;
          };
          allow-delete = lib.mkOption {
            type = types.bool;
            description = "Allow delete files/folders.";
            default = false;
          };
          allow-search = lib.mkOption {
            type = types.bool;
            description = "Allow search files/folders.";
            default = false;
          };
          allow-symlink = lib.mkOption {
            type = types.bool;
            description = "Allow symlink to files/folders outside root directory.";
            default = false;
          };
          allow-archive = lib.mkOption {
            type = types.bool;
            description = "Allow zip archive generation.";
            default = false;
          };
          enable-cors = lib.mkOption {
            type = types.bool;
            description = "Enable CORS, sets `Access-Control-Allow-Origin: *`.";
            default = false;
          };
          render-index = lib.mkOption {
            type = types.bool;
            description = "Serve index.html when requesting a directory, returns 404 if not found index.html.";
            default = false;
          };
          render-try-index = lib.mkOption {
            type = types.bool;
            description = "Serve index.html when requesting a directory, returns directory listing if not found index.html.";
            default = false;
          };
          render-spa = lib.mkOption {
            type = types.bool;
            description = "Serve SPA(Single Page Application).";
            default = false;
          };
          assets = lib.mkOption {
            type = types.nullOr types.path;
            description = "Set the path to the assets directory for overriding the built-in assets.";
            default = null;
          };
          log-format = lib.mkOption {
            type = types.nullOr types.str;
            description = "Customize http log format.";
            default = null;
            example = lib.literalExpression ''
              "$remote_addr \"$request\" $status"
            '';
          };
          compress = lib.mkOption {
            type = types.enum [
              "none"
              "low"
              "medium"
              "high"
            ];
            description = "Customize http log format.";
            default = "none";
          };
          tls-cert = lib.mkOption {
            type = types.nullOr types.path;
            description = "Path to an SSL/TLS certificate to serve with HTTPS.";
            default = null;
          };
          tls-key = lib.mkOption {
            type = types.nullOr types.path;
            description = "Path to the SSL/TLS certificate's private key.";
            default = null;
          };
        };
      };
      description = "Settings for dufs.";
    };
    authFile = lib.mkOption {
      type = types.nullOr types.path;
      description = ''
        Path to file containing auth roles (e.g. user:pass@/dir1:rw,/dir2), one per line.

        Passwords may be hashed, see https://github.com/sigoden/dufs#hashed-password.
      '';
      default = null;
    };
    openFirewall = lib.mkOption {
      type = types.bool;
      description = "Open firewall on configured port.";
      default = false;
    };
    user = lib.mkOption {
      type = types.str;
      description = "User to run dufs under.";
      default = "dufs";
    };
    group = lib.mkOption {
      type = types.str;
      description = "Group to run dufs under.";
      default = "dufs";
    };
  };
  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.settings.port ];
    systemd.services.dufs =
      let
        settings = lib.filterAttrs (_: v: v != null) cfg.settings;
        pathWritable = settings.allow-all || settings.allow-upload || settings.allow-delete;
      in
      {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        environment.DUFS_CONFIG = (pkgs.formats.yaml { }).generate "dufs-config.yaml" settings;
        script = ''
          ${lib.optionalString (cfg.authFile != null) ''
            export DUFS_AUTH=$(tr '\n' '|' < ${lib.escapeShellArg cfg.authFile} | sed 's/|$//')
          ''}
          exec ${lib.escapeShellArg (lib.getExe cfg.package)}
        '';
        serviceConfig = {
          BindReadOnlyPaths =
            [ builtins.storeDir ]
            ++ lib.optional (!pathWritable) settings.serve-path
            ++ lib.optional (cfg.authFile != null) cfg.authFile;
          BindPaths = lib.mkIf pathWritable settings.serve-path;
          CapabilityBoundingSet = "";
          DeviceAllow = "";
          Group = cfg.group;
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
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_NETLINK"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          RootDirectory = "/run/dufs";
          RuntimeDirectory = "dufs";
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "~@resources"
            "~@privileged"
          ];
          User = cfg.user;
        };
      };
    users = {
      users.dufs = lib.mkIf (cfg.user == "dufs") {
        group = cfg.group;
        home = cfg.settings.serve-path;
        isSystemUser = true;
      };
      groups.dufs = lib.mkIf (cfg.group == "dufs") { };
    };
  };
  meta.maintainers = with lib.maintainers; [ jackwilsdon ];
}
