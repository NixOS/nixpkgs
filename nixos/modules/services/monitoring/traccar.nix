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
  expandCamelCase = lib.replaceStrings lib.upperChars (map (s: ".${s}") lib.lowerChars);
  mkConfigEntry = key: value: "<entry key='${expandCamelCase key}'>${value}</entry>";
  mkConfig =
    configurationOptions:
    pkgs.writeText "traccar.xml" ''
      <?xml version='1.0' encoding='UTF-8'?>
      <!DOCTYPE properties SYSTEM 'http://java.sun.com/dtd/properties.dtd'>
      <properties>
          ${builtins.concatStringsSep "\n" (lib.mapAttrsToList mkConfigEntry configurationOptions)}
      </properties>
    '';

  defaultConfig = {
    databaseDriver = "org.h2.Driver";
    databasePassword = "";
    databaseUrl = "jdbc:h2:${stateDirectory}/traccar";
    databaseUser = "sa";
    loggerConsole = "true";
    mediaPath = "${stateDirectory}/media";
    templatesRoot = "${stateDirectory}/templates";
  };
in
{
  options.services.traccar = {
    enable = lib.mkEnableOption "Traccar, an open source GPS tracking system";
    settings = lib.mkOption {
      apply = lib.recursiveUpdate defaultConfig;
      default = defaultConfig;
      description = ''
        {file}`config.xml` configuration as a Nix attribute set.
        Attribute names are translated from camelCase to dot-separated strings. For instance:
        {option}`mailSmtpPort = "25"`
        would result in the following configuration property:
        `<entry key='mail.smtp.port'>25</entry>`
        Configuration options should match those described in
        [Traccar - Configuration File](https://www.traccar.org/configuration-file/).
        Secret tokens should be specified using {option}`environmentFile`
        instead of this world-readable attribute set.
      '';
    };
    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        File containing environment variables to substitute in the configuration before starting Traccar.

        Can be used for storing the secrets without making them available in the world-readable Nix store.

        For example, you can set {option}`services.traccar.settings.databasePassword = "$TRACCAR_DB_PASSWORD"`
        and then specify `TRACCAR_DB_PASSWORD="<secret>"` in the environment file.
        This value will get substituted in the configuration file.
      '';
    };
  };

  config =
    let
      configuration = mkConfig cfg.settings;
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
          EnvironmentFile = cfg.environmentFile;
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
