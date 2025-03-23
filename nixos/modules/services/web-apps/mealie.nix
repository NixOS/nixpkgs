{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.mealie;
  pkg = cfg.package;
in
{
  options.services.mealie = {
    enable = lib.mkEnableOption "Mealie, a recipe manager and meal planner";

    package = lib.mkPackageOption pkgs "mealie" { };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "Address on which the service should listen.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 9000;
      description = "Port on which to serve the Mealie service.";
    };

    settings = lib.mkOption {
      type = with lib.types; attrsOf anything;
      default = { };
      description = ''
        Configuration of the Mealie service.

        See [the mealie documentation](https://nightly.mealie.io/documentation/getting-started/installation/backend-config/) for available options and default values.
      '';
      example = {
        ALLOW_SIGNUP = "false";
      };
    };

    credentialsFile = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
      example = "/run/secrets/mealie-credentials.env";
      description = ''
        File containing credentials used in mealie such as {env}`POSTGRES_PASSWORD`
        or sensitive LDAP options.

        Expects the format of an `EnvironmentFile=`, as described by {manpage}`systemd.exec(5)`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.mealie = {
      description = "Mealie, a self hosted recipe manager and meal planner";

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        PRODUCTION = "true";
        API_PORT = toString cfg.port;
        BASE_URL = "http://localhost:${toString cfg.port}";
        DATA_DIR = "/var/lib/mealie";
        CRF_MODEL_PATH = "/var/lib/mealie/model.crfmodel";
      } // (builtins.mapAttrs (_: val: toString val) cfg.settings);

      serviceConfig = {
        DynamicUser = true;
        User = "mealie";
        ExecStartPre = "${pkg}/libexec/init_db";
        ExecStart = "${lib.getExe pkg} -b ${cfg.listenAddress}:${builtins.toString cfg.port}";
        EnvironmentFile = lib.mkIf (cfg.credentialsFile != null) cfg.credentialsFile;
        StateDirectory = "mealie";
        StandardOutput = "journal";
      };
    };
  };
}
