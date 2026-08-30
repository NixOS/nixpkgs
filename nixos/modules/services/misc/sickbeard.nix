{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let

  name = "sickbeard";

  cfg = config.services.sickbeard;
  opt = options.services.sickbeard;
  sickbeard = cfg.package;

in
{

  ###### interface

  options = {
    services.sickbeard = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable the sickbeard server.";
      };
      package = lib.mkPackageOption pkgs "sickbeard" {
        example = "sickrage";
        extraDescription = ''
          Enable `pkgs.sickrage` or `pkgs.sickgear`
          as an alternative to SickBeard
        '';
      };
      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/${name}";
        description = "Path where to store data files.";
      };
      configFile = lib.mkOption {
        type = lib.types.path;
        default = "${cfg.dataDir}/config.ini";
        defaultText = lib.literalExpression ''"''${config.${opt.dataDir}}/config.ini"'';
        description = "Path to config file.";
      };
      port = lib.mkOption {
        type = lib.types.port;
        default = 8081;
        description = "Port to bind to.";
      };
      user = lib.mkOption {
        type = lib.types.str;
        default = name;
        description = "User to run the service as";
      };
      group = lib.mkOption {
        type = lib.types.str;
        default = name;
        description = "Group to run the service as";
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    users.users = lib.optionalAttrs (cfg.user == name) {
      ${name} = {
        uid = config.ids.uids.sickbeard;
        group = cfg.group;
        description = "sickbeard user";
        home = cfg.dataDir;
        createHome = true;
      };
    };

    users.groups = lib.optionalAttrs (cfg.group == name) {
      ${name}.gid = config.ids.gids.sickbeard;
    };

    systemd.services.sickbeard = {
      description = "Sickbeard Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${sickbeard}/bin/${sickbeard.pname} --datadir ${cfg.dataDir} --config ${cfg.configFile} --port ${toString cfg.port}";
      };
    };
  };
}
