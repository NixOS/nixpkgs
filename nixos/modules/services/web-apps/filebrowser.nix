{ config, lib, pkgs, ... }:

let
  inherit (lib) generators types hasPrefix literalExpression mkEnableOption mkIf
                mkOption mkPackageOption optional optionalAttrs;

  cfg = config.services.filebrowser;
  enableDynamicUser =
    assert cfg.user != "filebrowser" -> cfg.group != "filebrowser";
    cfg.user == "filebrowser";
  enableTls =
    assert cfg.tlsCertificate != null -> cfg.tlsCertificateKey != null;
    cfg.tlsCertificate != null;

  configFile = pkgs.writeText "filebrowser-config.json" (generators.toJSON {} ({
      database = "/var/lib/filebrowser/filebrowser.db";
      root = cfg.rootDir;
      inherit (cfg) address port;
    } // (optionalAttrs enableTls {
      cert = cfg.tlsCertificate;
      key = cfg.tlsCertificateKey;
    })
    // (optionalAttrs (cfg.baseUrl != null) { baseurl = cfg.baseUrl; })
    // (optionalAttrs (cfg.cacheDir != null) { cache-dir = cfg.cacheDir; })
    // (optionalAttrs cfg.disableThumbnails { disable-thumbnails = true; })
    // (optionalAttrs cfg.disablePreviewResize { disable-preview-resize = true; })
    // (optionalAttrs cfg.disableCommandRunner { disable-exec = true; })
    // (optionalAttrs cfg.disableTypeDetectionByHeader { disable-type-detection-by-header = true; })
  ));
in
{
  options.services.filebrowser = {
    enable = mkEnableOption
      "File Browser is a web application for managing files and directories";

    package = mkPackageOption pkgs "filebrowser" { };

    # https://github.com/filebrowser/filebrowser/blob/bd3c1941ff8289a5dae877e08f7e25fa9b2a92c5/cmd/root.go#L56
    address = mkOption {
      type = types.str;
      default = "127.0.0.1";
      example = literalExpression "0.0.0.0";
      description = ''
        Address the service should listen on.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 8080;
      description = "Port the service should listen on.";
    };

    tlsCertificate = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Optional TLS certificate";
    };

    tlsCertificateKey = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Key for TLS certificate. Must be set if `services.filebrowser.tlsCertficate`
        is used.
      '';
    };

    rootDir = mkOption {
      type = types.path;
      default = "/var/lib/filebrowser/files";
      description = ''
        Path to the directory that should be exposed by File Browser.
      '';
    };

    baseUrl = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "/files";
      description = ''
        Subpath to serve the web interface at. Useful in combination with a
        reverse proxy.
      '';
    };

    cacheDir = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = literalExpression "/var/cache/filebrowser";
      description = "File cache directory. Disabled by default.";
    };

    tokenExpirationTime = mkOption {
      type = types.str;
      default = "2h";
      example = "12h";
      description = "User session timeout";
    };

    imageProcessors = mkOption {
      type = types.int;
      default = 4;
      example = 2;
      description = "Number of image processes.";
    };

    disableThumbnails = mkEnableOption "Disable image thumbnails.";
    disablePreviewResize = mkEnableOption "Disable resize of image previews.";
    disableCommandRunner = mkEnableOption "Disable the Command Runner feature.";
    disableTypeDetectionByHeader = mkEnableOption
      "Disable file type detection by reading file headers.";

    user = mkOption {
      type = types.str;
      default = "filebrowser";
      description = ''
        If `services.filebrowser.group` is set, this must be set as well. Must
        already exist.
      '';
    };

    group = mkOption {
      type = types.str;
      default = "filebrowser";
      description = ''
        If `services.filebrowser.user` is set, this must be set as well. Must
        already exist.
      '';
    };

    openFirewall = mkEnableOption "Open the port in the firewall.";
  };

  config = mkIf cfg.enable {
    systemd.services.filebrowser = {
      description = "File Browser service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment.HOME = "/var/lib/filebrowser";

      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "filebrowser";
        BindPaths = optional (!(hasPrefix "/var/lib/filebrowser" cfg.rootDir)) cfg.rootDir;

        DynamicUser = enableDynamicUser;

        # Basic hardening
        NoNewPrivileges = "yes";
        PrivateTmp = "yes";
        PrivateDevices = "yes";
        DevicePolicy = "closed";
        ProtectSystem = "strict";
        ProtectHome = "tmpfs";
        ProtectControlGroups = "yes";
        ProtectKernelModules = "yes";
        ProtectKernelTunables = "yes";
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";
        RestrictNamespaces = "yes";
        RestrictRealtime = "yes";
        RestrictSUIDSGID = "yes";
        MemoryDenyWriteExecute = "yes";
        LockPersonality = "yes";

        ExecStartPre = ''
          ${pkgs.coreutils}/bin/mkdir -p ${toString cfg.rootDir}
        '';

        ExecStart = "${cfg.package}/bin/filebrowser --config ${configFile}";
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];
  };

  meta.maintainers = with lib.maintainers; [ christoph-heiss ];
}
