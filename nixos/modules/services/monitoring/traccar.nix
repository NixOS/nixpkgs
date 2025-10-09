{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.traccar;
  stateDirectory = "/var/lib/traccar";
  configFilePath = "${stateDirectory}/config.xml";

  # Map leafs to XML <entry> elements as expected by traccar, using
  # dot-separated keys for nested attribute paths.
  mapLeafs = lib.mapAttrsRecursive (
    path: value: "<entry key='${lib.concatStringsSep "." path}'>${value}</entry>"
  );

  mkConfigEntry = config: lib.collect builtins.isString (mapLeafs config);

  mkConfig =
    configurationOptions:
    pkgs.writeText "traccar.xml" ''
      <?xml version='1.0' encoding='UTF-8'?>
      <!DOCTYPE properties SYSTEM 'http://java.sun.com/dtd/properties.dtd'>
      <properties>
          ${builtins.concatStringsSep "\n" (mkConfigEntry configurationOptions)}
      </properties>
    '';

  defaultConfig = {
    database = {
      driver = "org.h2.Driver";
      password = "";
      url = "jdbc:h2:${stateDirectory}/traccar";
      user = "sa";
    };
    logger.console = "true";
    media.path = "${stateDirectory}/media";
    templates.root = "${stateDirectory}/templates";
  };

in
{
  options.services.traccar = {
    enable = lib.mkEnableOption "Traccar, an open source GPS tracking system";
    settingsFile = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
      description = ''
        File used as configuration for traccar. When specified, {option}`settings` is ignored.
      '';
    };
    settings = lib.mkOption {
      apply = lib.recursiveUpdate defaultConfig;
      default = defaultConfig;
      description = ''
        {file}`config.xml` configuration as a Nix attribute set.
        This option is ignored if `settingsFile` is set.

        Nested attributes get translated to a properties entry in the traccar configuration.
        For instance: `mail.smtp.port = "25"` results in the following entry:
        `<entry key='mail.smtp.port'>25</entry>`

        Secrets should be specified using {option}`environmentFile`
        instead of this world-readable attribute set.
        [Traccar - Configuration File](https://www.traccar.org/configuration-file/).
      '';
    };
    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        File containing environment variables to substitute in the configuration before starting Traccar.

        Can be used for storing the secrets without making them available in the world-readable Nix store.

        For example, you can set {option}`services.traccar.settings.database.password = "$TRACCAR_DB_PASSWORD"`
        and then specify `TRACCAR_DB_PASSWORD="<secret>"` in the environment file.
        This value will get substituted in the configuration file.
      '';
    };
  };

  config =
    let
      configuration = if cfg.settingsFile != null then cfg.settingsFile else mkConfig cfg.settings;
    in
    lib.mkIf cfg.enable {
      systemd.services.traccar = {
        enable = true;
        description = "Traccar";

        after = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];
        wants = [ "network-online.target" ];

        preStart = ''
          # Copy new templates into our state directory.
          cp -a --update=none ${pkgs.traccar}/templates ${stateDirectory}
          test -f '${configFilePath}' && rm -f '${configFilePath}'

          # Substitute the configFile from Envvars read from EnvironmentFile
          old_umask=$(umask)
          umask 0177
          ${lib.getExe pkgs.envsubst} \
            -i ${configuration} \
            -o ${configFilePath}
          umask $old_umask
        '';

        serviceConfig = {
          DynamicUser = true;
          EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
          ExecStart = "${lib.getExe pkgs.traccar} ${configFilePath}";
          LockPersonality = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateTmp = true;
          PrivateUsers = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectSystem = "strict";
          Restart = "on-failure";
          RestartSec = 10;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          StateDirectory = "traccar";
          SuccessExitStatus = 143;
          Type = "simple";
          # Set the working directory to traccar's package.
          # Traccar only searches for the DB migrations relative to it's WorkingDirectory and nothing worked to
          # work around this. To avoid copying the migrations over to the state directory, we use the package as
          # WorkingDirectory.
          WorkingDirectory = "${pkgs.traccar}";
        };
      };
    };
}
