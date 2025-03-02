{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.glpiAgent;

  settingsType =
    with lib.types;
    attrsOf (oneOf [
      bool
      int
      str
      (listOf str)
    ]);

  formatValue =
    v:
    if lib.isBool v then
      if v then "1" else "0"
    else if lib.isList v then
      lib.concatStringsSep "," v
    else
      toString v;

  configContent = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (k: v: "${k} = ${formatValue v}") cfg.settings
  );

  configFile = pkgs.writeText "agent.cfg" configContent;

in
{
  options = {
    services.glpiAgent = {
      enable = lib.mkEnableOption "GLPI Agent";

      package = lib.mkPackageOption pkgs "glpi-agent" { };

      settings = lib.mkOption {
        type = settingsType;
        default = { };
        description = ''
          GLPI Agent configuration options.
          See https://glpi-agent.readthedocs.io/en/latest/configuration.html for all available options.

          The 'server' option is mandatory and must point to your GLPI server.
        '';
        example = lib.literalExpression ''
          {
            server = [ "https://glpi.example.com/inventory" ];
            delaytime = 3600;
            tag = "production";
            logger = [ "stderr" "file" ];
            debug = 1;
            "no-category" = [ "printer" "software" ];
          }
        '';
      };

      stateDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/glpi-agent";
        description = "Directory where GLPI Agent stores its state.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.settings ? server;
        message = "GLPI Agent requires a server to be configured in services.glpiAgent.settings.server";
      }
    ];

    systemd.tmpfiles.settings."10-glpi-agent" = {
      ${cfg.stateDir} = {
        d = {
          mode = "0755";
          user = "root";
          group = "root";
        };
      };
    };

    systemd.services.glpi-agent = {
      description = "GLPI Agent";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} --conf-file ${configFile} --vardir ${cfg.stateDir} --daemon --no-fork";
        Restart = "on-failure";
      };
    };
  };
}
