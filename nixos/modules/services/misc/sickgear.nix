{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.services.sickgear;
  opt = options.services.sickgear;
in
{
  imports = [
    (lib.mkRenamedOptionModule [ "services" "sickbeard" ] [ "services" "sickgear" ])
  ];

  ###### interface

  options = {
    services.sickgear = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable the sickgear server.";
      };
      package = lib.mkPackageOption pkgs "sickgear" { };
      dataDir = lib.mkOption {
        type = lib.types.path;
        default =
          if lib.versionAtLeast config.system.stateVersion "25.11" then
            "/var/lib/sickgear"
          else
            "/var/lib/sickbeard";
        defaultText = lib.literalExpression ''
          if lib.versionAtLeast config.system.stateVersion "25.11" then
            "/var/lib/sickgear"
          else
            "/var/lib/sickbeard"
        '';
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
        default = if lib.versionAtLeast config.system.stateVersion "25.11" then "sickgear" else "sickbeard";
        defaultText = lib.literalExpression ''
          if lib.versionAtLeast config.system.stateVersion "25.11" then "sickgear" else "sickbeard"
        '';
        description = "User to run the service as";
      };
      group = lib.mkOption {
        type = lib.types.str;
        default = if lib.versionAtLeast config.system.stateVersion "25.11" then "sickgear" else "sickbeard";
        defaultText = lib.literalExpression ''
          if lib.versionAtLeast config.system.stateVersion "25.11" then "sickgear" else "sickbeard"
        '';
        description = "Group to run the service as";
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    users.users = lib.optionalAttrs (cfg.user == opt.user.default) {
      ${cfg.user} = {
        uid = config.ids.uids.sickgear;
        group = cfg.group;
        description = "sickgear user";
        home = cfg.dataDir;
        createHome = true;
      };
    };

    users.groups = lib.optionalAttrs (cfg.group == opt.user.default) {
      ${cfg.group}.gid = config.ids.gids.sickgear;
    };

    systemd.services.sickgear = {
      description = "Sickgear Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${lib.getExe cfg.package} --datadir ${cfg.dataDir} --config ${cfg.configFile} --port ${toString cfg.port}";
      };
    };
  };
}
