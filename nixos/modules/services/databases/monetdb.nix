{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.monetdb;

in
{
  meta.maintainers = with lib.maintainers; [ StillerHarpo ];

  ###### interface
  options = {
    services.monetdb = {

      enable = lib.mkEnableOption "the MonetDB database server";

      package = lib.mkPackageOption pkgs "monetdb" { };

      user = lib.mkOption {
        type = lib.types.str;
        default = "monetdb";
        description = "User account under which MonetDB runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "monetdb";
        description = "Group under which MonetDB runs.";
      };

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/monetdb";
        description = "Data directory for the dbfarm.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 50000;
        description = "Port to listen on.";
      };

      listenAddress = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        example = "0.0.0.0";
        description = "Address to listen on.";
      };
    };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {

    users.users.monetdb = lib.mkIf (cfg.user == "monetdb") {
      uid = config.ids.uids.monetdb;
      group = cfg.group;
      description = "MonetDB user";
      home = cfg.dataDir;
      createHome = true;
    };

    users.groups.monetdb = lib.mkIf (cfg.group == "monetdb") {
      gid = config.ids.gids.monetdb;
      members = [ cfg.user ];
    };

    environment.systemPackages = [ cfg.package ];

    systemd.services.monetdb = {
      description = "MonetDB database server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = [ cfg.package ];
      unitConfig.RequiresMountsFor = "${cfg.dataDir}";
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/monetdbd start -n ${cfg.dataDir}";
        ExecStop = "${cfg.package}/bin/monetdbd stop ${cfg.dataDir}";
      };
      preStart = ''
        if [ ! -e ${cfg.dataDir}/.merovingian_properties ]; then
          # Create the dbfarm (as cfg.user)
          ${cfg.package}/bin/monetdbd create ${cfg.dataDir}
        fi

        # Update the properties
        ${cfg.package}/bin/monetdbd set port=${toString cfg.port} ${cfg.dataDir}
        ${cfg.package}/bin/monetdbd set listenaddr=${cfg.listenAddress} ${cfg.dataDir}
      '';
    };

  };
}
