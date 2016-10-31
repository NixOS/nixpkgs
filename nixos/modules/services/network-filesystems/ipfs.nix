{ config, lib, pkgs, ... }:

with lib;

let
  inherit (pkgs) ipfs;

  cfg = config.services.ipfs;


  ipfsFlags = ''${if cfg.autoMigrate then "--migrate" else ""} ${if cfg.enableGC then "--enable-gc" else ""} ${toString cfg.extraFlags}'';

in

{

  ###### interface

  options = {

    services.ipfs = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to start a daemon for the Interplanetary
          file system (IPFS).
        '';
      };

      user = mkOption {
        type = types.str;
        default = "ipfs";
        description = "User under which the IPFS daemon runs";
      };

      group = mkOption {
        type = types.str;
        default = "ipfs";
        description = "Group under which the IPFS daemon runs";
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/ipfs";
        description = "The data dir for IPFS";
      };

      autoMigrate = mkOption {
        default = false;
        description = ''
          Whether IPFS should try to migrate the file system automatically.
        '';
      };

      enableGC = mkOption {
        default = false;
        description = ''
          Whether to enable automatic garbadge collection.
        '';
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        description = "Extra flags passed to the IPFS daemon";
        default = [];
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.ipfs ];

    users.extraUsers = optionalAttrs (cfg.user == "ipfs") singleton {
      name = "ipfs";
      group = cfg.group;
      home = cfg.dataDir;
      createHome = false;
      uid = config.ids.uids.ipfs;
      description = "IPFS daemon user";
    };

    users.extraGroups = optionalAttrs (cfg.group == "ipfs") singleton {
      name = "ipfs";
      gid = config.ids.gids.ipfs;
    };

    systemd.services.ipfs = {
      description = "IPFS Daemon";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "local-fs.target" ];
      path  = [ pkgs.ipfs pkgs.su pkgs.bash ];

      preStart =
        ''
          install -m 0755 -o ${cfg.user} -g ${cfg.group} -d ${cfg.dataDir}
          if [[ ! -d ${cfg.dataDir}/.ipfs ]]; then
            cd ${cfg.dataDir}
            ${pkgs.su}/bin/su -s ${pkgs.bash}/bin/sh ${cfg.user} -c "${ipfs}/bin/ipfs init"
          fi
        '';

      serviceConfig = {
        ExecStart = "${ipfs}/bin/ipfs daemon ${ipfsFlags}";
        User = cfg.user;
        Group = cfg.group;
        PermissionsStartOnly = true;
      };
    };
  };
}
