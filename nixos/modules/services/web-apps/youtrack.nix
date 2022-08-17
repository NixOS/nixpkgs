{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.youtrack;

  extraAttr = concatStringsSep " " (mapAttrsToList (k: v: "-D${k}=${v}") (stdParams // cfg.extraParams));
  mergeAttrList = lib.foldl' lib.mergeAttrs {};

  stdParams = mergeAttrList [
    (optionalAttrs (cfg.baseUrl != null) {
      "jetbrains.youtrack.baseUrl" = cfg.baseUrl;
    })
    {
    "java.aws.headless" = "true";
    "jetbrains.youtrack.disableBrowser" = "true";
    }
  ];
in
{
  options.services.youtrack = {

    enable = mkEnableOption "YouTrack service";

    address = mkOption {
      description = lib.mdDoc ''
        The interface youtrack will listen on.
      '';
      default = "127.0.0.1";
      type = types.str;
    };

    baseUrl = mkOption {
      description = lib.mdDoc ''
        Base URL for youtrack. Will be auto-detected and stored in database.
      '';
      type = types.nullOr types.str;
      default = null;
    };

    extraParams = mkOption {
      default = {};
      description = lib.mdDoc ''
        Extra parameters to pass to youtrack. See
        https://www.jetbrains.com/help/youtrack/standalone/YouTrack-Java-Start-Parameters.html
        for more information.
      '';
      example = literalExpression ''
        {
          "jetbrains.youtrack.overrideRootPassword" = "tortuga";
        }
      '';
      type = types.attrsOf types.str;
    };

    package = mkOption {
      description = lib.mdDoc ''
        Package to use.
      '';
      type = types.package;
      default = pkgs.youtrack;
      defaultText = literalExpression "pkgs.youtrack";
    };

    port = mkOption {
      description = lib.mdDoc ''
        The port youtrack will listen on.
      '';
      default = 8080;
      type = types.int;
    };

    statePath = mkOption {
      description = lib.mdDoc ''
        Where to keep the youtrack database.
      '';
      type = types.path;
      default = "/var/lib/youtrack";
    };

    virtualHost = mkOption {
      description = lib.mdDoc ''
        Name of the nginx virtual host to use and setup.
        If null, do not setup anything.
      '';
      default = null;
      type = types.nullOr types.str;
    };

    jvmOpts = mkOption {
      description = lib.mdDoc ''
        Extra options to pass to the JVM.
        See https://www.jetbrains.com/help/youtrack/standalone/Configure-JVM-Options.html
        for more information.
      '';
      type = types.separatedString " ";
      example = "-XX:MetaspaceSize=250m";
      default = "";
    };

    maxMemory = mkOption {
      description = lib.mdDoc ''
        Maximum Java heap size
      '';
      type = types.str;
      default = "1g";
    };

    maxMetaspaceSize = mkOption {
      description = lib.mdDoc ''
        Maximum java Metaspace memory.
      '';
      type = types.str;
      default = "350m";
    };
  };

  config = mkIf cfg.enable {

    systemd.services.youtrack = {
      environment.HOME = cfg.statePath;
      environment.YOUTRACK_JVM_OPTS = "${extraAttr}";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [ unixtools.hostname ];
      serviceConfig = {
        Type = "simple";
        User = "youtrack";
        Group = "youtrack";
        Restart = "on-failure";
        ExecStart = ''${cfg.package}/bin/youtrack --J-Xmx${cfg.maxMemory} --J-XX:MaxMetaspaceSize=${cfg.maxMetaspaceSize} ${cfg.jvmOpts} ${cfg.address}:${toString cfg.port}'';
      };
    };

    users.users.youtrack = {
      description = "Youtrack service user";
      isSystemUser = true;
      home = cfg.statePath;
      createHome = true;
      group = "youtrack";
    };

    users.groups.youtrack = {};

    services.nginx = mkIf (cfg.virtualHost != null) {
      upstreams.youtrack.servers."${cfg.address}:${toString cfg.port}" = {};
      virtualHosts.${cfg.virtualHost}.locations = {
        "/" = {
          proxyPass = "http://youtrack";
          extraConfig = ''
            client_max_body_size 10m;
            proxy_http_version 1.1;
            proxy_set_header X-Forwarded-Host $http_host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };

        "/api/eventSourceBus" = {
          proxyPass = "http://youtrack";
          extraConfig = ''
            proxy_cache off;
            proxy_buffering off;
            proxy_read_timeout 86400s;
            proxy_send_timeout 86400s;
            proxy_set_header Connection "";
            chunked_transfer_encoding off;
            client_max_body_size 10m;
            proxy_http_version 1.1;
            proxy_set_header X-Forwarded-Host $http_host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };

      };
    };

  };
}
