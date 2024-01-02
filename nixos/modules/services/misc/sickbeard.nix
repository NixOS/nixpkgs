{ config, lib, options, pkgs, ... }:

with lib;

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
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Whether to enable the sickbeard server.";
      };
      package = mkPackageOption pkgs "sickbeard" {
        example = "sickrage";
        extraDescription = ''
          Enable `pkgs.sickrage` or `pkgs.sickgear`
          as an alternative to SickBeard
        '';
      };
      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/${name}";
        description = lib.mdDoc "Path where to store data files.";
      };
      configFile = mkOption {
        type = types.path;
        default = "${cfg.dataDir}/config.ini";
        defaultText = literalExpression ''"''${config.${opt.dataDir}}/config.ini"'';
        description = lib.mdDoc "Path to config file.";
      };
      port = mkOption {
        type = types.ints.u16;
        default = 8081;
        description = lib.mdDoc "Port to bind to.";
      };
      user = mkOption {
        type = types.str;
        default = name;
        description = lib.mdDoc "User to run the service as";
      };
      group = mkOption {
        type = types.str;
        default = name;
        description = lib.mdDoc "Group to run the service as";
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    users.users = optionalAttrs (cfg.user == name) {
      ${name} = {
        uid = config.ids.uids.sickbeard;
        group = cfg.group;
        description = "sickbeard user";
        home = cfg.dataDir;
        createHome = true;
      };
    };

    users.groups = optionalAttrs (cfg.group == name) {
      ${name}.gid = config.ids.gids.sickbeard;
    };

    systemd.services.sickbeard = {
      description = "Sickbeard Server";
      wantedBy    = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${sickbeard}/bin/${sickbeard.pname} --datadir ${cfg.dataDir} --config ${cfg.configFile} --port ${toString cfg.port}";
      };
    };
  };
}
