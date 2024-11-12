{ config, lib, options, pkgs, ... }:
let

  name = "headphones";

  cfg = config.services.headphones;
  opt = options.services.headphones;

in

{

  ###### interface

  options = {
    services.headphones = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable the headphones server.";
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
      host = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        description = "Host to listen on.";
      };
      port = lib.mkOption {
        type = lib.types.ints.u16;
        default = 8181;
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
        uid = config.ids.uids.headphones;
        group = cfg.group;
        description = "headphones user";
        home = cfg.dataDir;
        createHome = true;
      };
    };

    users.groups = lib.optionalAttrs (cfg.group == name) {
      ${name}.gid = config.ids.gids.headphones;
    };

    systemd.services.headphones = {
        description = "Headphones Server";
        wantedBy    = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          User = cfg.user;
          Group = cfg.group;
          ExecStart = "${pkgs.headphones}/bin/headphones --datadir ${cfg.dataDir} --config ${cfg.configFile} --host ${cfg.host} --port ${toString cfg.port}";
        };
    };
  };
}
