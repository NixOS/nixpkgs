{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.services.xonotic;

  serverModule = types.submodule ({ name, ... }: {
    options = {
  
      hostName = mkOption {
        type = types.str;
        description = "name of the server";
        default = name;
      };

      port = mkOption {
        type = types.ints.u16;
        description = "server port";
        default = 26000;
      };

      options = mkOption {
        type = types.lines;
        description = "server config written in server.cfg";
        example = ''
          sv_public 1
        '';
        default = "";
      };
    };
  });
in {
  options = {
    services.xonotic = {
      enable = mkEnableOption "Xonotic servers";

      servers = mkOption {
        type = types.loaOf serverModule;
        default = {};
        description = "available serves";
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/xonotic";
        description = "directory for xonotic state";
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.xonotic = {
      description = "xonetic server service user";
      home = cfg.dataDir;
      createHome = true;
      isSystemUser = true;
    };

    systemd.services = (lib.mapAttrs' (name: config:
    let
      userDir = "${cfg.dataDir}/${name}";
    in lib.nameValuePair "xonotic-${name}" {
      description = "Xonotic server ${config.hostName}";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.xonotic-dedicated}/bin/xonotic-dedicated -userdir ${userDir}";
        Restart = "always";
        User = "xonotic";
        WorkingDirectory = userDir;
      };

      preStart = let
          configFile = pkgs.writeText "server.cfg" ''
            hostname "${config.hostName}"
            port ${toString config.port}
            ${config.options}
          '';
        in ''
          mkdir -p ${userDir}/data/
          ln -sf ${configFile} ${userDir}/data/server.cfg
          chown -R xonotic ${userDir}
      '';
    }) cfg.servers);
  };
}
