{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.tusd;
  username = "tusd";
  groupname = "tusd";

  args = [
    "-host=${cfg.host}"
    "-port=${toString cfg.port}"
    "-base-path=${cfg.basePath}"
    "-upload-dir=${cfg.uploadDir}"
  ]
  ++ lib.optional cfg.behindProxy "-behind-proxy"
  ++ lib.optional (cfg.maxSize != null) "-max-size=${toString cfg.maxSize}"
  ++ lib.optional (cfg.networkTimeout != null) "-network-timeout=${cfg.networkTimeout}"
  ++ lib.optional (cfg.hooksHttp != null) "-hooks-http=${cfg.hooksHttp}"
  ++ lib.optional (
    cfg.hooksEnabledEvents != [ ]
  ) "-hooks-enabled-events=${lib.concatStringsSep "," cfg.hooksEnabledEvents}"
  ++ cfg.extraArgs;
in
{
  meta.maintainers = with lib.maintainers; [ m1-s ];

  options.services.tusd = {
    enable = lib.mkEnableOption "tus resumable upload protocol server";

    host = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "The host to bind the HTTP server to.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "The port to bind the HTTP server to.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall port for tusd.";
    };

    basePath = lib.mkOption {
      type = lib.types.str;
      default = "/files/";
      description = "The basepath of the HTTP server.";
    };

    uploadDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/tusd/data";
      description = "The directory to store uploads in.";
    };

    behindProxy = lib.mkEnableOption null // {
      description = "Whether to respect X-Forwarded-* and similar headers which may be set by proxies.";
    };

    maxSize = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = "The maximum size of a single upload in bytes.";
    };

    networkTimeout = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        The timeout for reading the request and writing the response.
        If tusd does not receive data for this duration,
        it will consider the connection dead.
      '';
      example = "30s";
    };

    hooksHttp = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "The HTTP endpoint to which hook events will be sent to.";
      example = "http://localhost:8081/hooks";
    };

    hooksEnabledEvents = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "The list of enabled hook events.";
      example = [
        "pre-create"
        "post-finish"
      ];
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional arguments given to tusd.";
      example = [
        "-verbose"
        "-log-format=json"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${username} = {
      isSystemUser = true;
      group = groupname;
    };
    users.groups.${groupname} = { };

    # tusd knows how to create subdirectories in this folder but we have to
    # create the root folder ourselves.
    systemd.tmpfiles.settings."tusd".${cfg.uploadDir}.d = {
      user = username;
      group = groupname;
      # default taken from https://github.com/tus/tusd/blob/55a096a10942b85360664a1e8aea7bd758272053/pkg/filestore/filestore.go#L37
      mode = "0775";
    };

    systemd.services.tusd = {
      description = "tusd - tus resumable upload protocol server";
      documentation = [ "https://github.com/tus/tusd" ];

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        User = username;
        Group = groupname;

        ExecStart = lib.escapeShellArgs ([ (lib.getExe pkgs.tusd) ] ++ args);
        Restart = "on-failure";

        StateDirectory = "tusd";

        # Hardening
        LockPersonality = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostUserNamespaces = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };
    };

    networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.port;
  };
}
