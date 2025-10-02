{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.pinchflat;
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    mkIf
    getExe
    literalExpression
    optional
    attrValues
    mapAttrs
    ;

  stateDir = "/var/lib/pinchflat";
in
{
  options = {
    services.pinchflat = {
      enable = mkEnableOption "pinchflat";

      mediaDir = mkOption {
        type = types.path;
        default = "${stateDir}/media";
        description = "The directory into which Pinchflat downloads videos.";
      };

      port = mkOption {
        type = types.port;
        default = 8945;
        description = "Port on which the Pinchflat web interface is available.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Open ports in the firewall for the Pinchflat web interface";
      };

      selfhosted = mkOption {
        type = types.bool;
        default = false;
        description = "Use a weak secret. If true, you are not required to provide a {env}`SECRET_KEY_BASE` through the `secretsFile` option. Do not use this option in production!";
      };

      logLevel = mkOption {
        type = types.enum [
          "debug"
          "info"
          "warning"
          "error"
        ];
        default = "info";
        description = "Log level for Pinchflat.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "pinchflat";
        description = ''
          User account under which Pinchflat runs.
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "pinchflat";
        description = ''
          Group under which Pinchflat runs.
        '';
      };

      extraConfig = mkOption {
        type =
          with types;
          attrsOf (
            nullOr (oneOf [
              bool
              int
              str
            ])
          );
        default = { };
        example = literalExpression ''
          {
            YT_DLP_WORKER_CONCURRENCY = 1;
          }
        '';
        description = ''
          The configuration of Pinchflat is handled through environment variables.
          The available configuration options can be found in [the Pinchflat README](https://github.com/kieraneglin/pinchflat/README.md#environment-variables).
        '';
      };

      secretsFile = mkOption {
        type = with types; nullOr path;
        default = null;
        example = "/run/secrets/pinchflat";
        description = ''
          Secrets like {env}`SECRET_KEY_BASE` and {env}`BASIC_AUTH_PASSWORD`
          should be passed to the service without adding them to the world-readable Nix store.

          Note that either this file needs to be available on the host on which `pinchflat` is running,
          or the option `selfhosted` must be `true`.
          Further, {env}`SECRET_KEY_BASE` has a minimum length requirement of 64 bytes.
          One way to generate such a secret is to use `openssl rand -hex 64`.

          As an example, the contents of the file might look like this:
          ```
          SECRET_KEY_BASE=...copy-paste a secret token here...
          BASIC_AUTH_USERNAME=...basic auth username...
          BASIC_AUTH_PASSWORD=...basic auth password...
          ```
        '';
      };

      package = mkPackageOption pkgs "pinchflat" { };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.selfhosted || !builtins.isNull cfg.secretsFile;
        message = "Either `selfhosted` must be true, or a `secretsFile` must be configured.";
      }
    ];

    systemd.services.pinchflat = {
      description = "pinchflat";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;

        StateDirectory = baseNameOf stateDir;
        Environment = [
          "PORT=${builtins.toString cfg.port}"
          "TZ=${config.time.timeZone}"
          "MEDIA_PATH=${cfg.mediaDir}"
          "CONFIG_PATH=${stateDir}"
          "DATABASE_PATH=${stateDir}/db/pinchflat.db"
          "LOG_PATH=${stateDir}/logs/pinchflat.log"
          "METADATA_PATH=${stateDir}/metadata"
          "EXTRAS_PATH=${stateDir}/extras"
          "TMPFILE_PATH=${stateDir}/tmp"
          "TZ_DATA_PATH=${stateDir}/extras/elixir_tz_data"
          "LOG_LEVEL=${cfg.logLevel}"
          "PHX_SERVER=true"
        ]
        ++ optional cfg.selfhosted [ "RUN_CONTEXT=selfhosted" ]
        ++ attrValues (mapAttrs (name: value: name + "=" + builtins.toString value) cfg.extraConfig);
        EnvironmentFile = optional (cfg.secretsFile != null) cfg.secretsFile;
        ExecStartPre = "${lib.getExe' cfg.package "migrate"}";
        ExecStart = "${getExe cfg.package} start";
        Restart = "on-failure";
      };
    };

    users.users = lib.mkIf (cfg.user == "pinchflat") {
      pinchflat = {
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = lib.mkIf (cfg.group == "pinchflat") {
      pinchflat = { };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}
