{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.solr;

in

{
  options = {
    services.solr = {
      enable = mkEnableOption (lib.mdDoc "Solr");

      package = mkOption {
        type = types.package;
        default = pkgs.solr;
        defaultText = literalExpression "pkgs.solr";
        description = lib.mdDoc "Which Solr package to use.";
      };

      port = mkOption {
        type = types.int;
        default = 8983;
        description = lib.mdDoc "Port on which Solr is ran.";
      };

      stateDir = mkOption {
        type = types.path;
        default = "/var/lib/solr";
        description = lib.mdDoc "The solr home directory containing config, data, and logging files.";
      };

      extraJavaOptions = mkOption {
        type = types.listOf types.str;
        default = [];
        description = lib.mdDoc "Extra command line options given to the java process running Solr.";
      };

      user = mkOption {
        type = types.str;
        default = "solr";
        description = lib.mdDoc "User under which Solr is ran.";
      };

      group = mkOption {
        type = types.str;
        default = "solr";
        description = lib.mdDoc "Group under which Solr is ran.";
      };
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    systemd.services.solr = {
      after = [ "network.target" "remote-fs.target" "nss-lookup.target" "systemd-journald-dev-log.socket" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        SOLR_HOME = "${cfg.stateDir}/data";
        LOG4J_PROPS = "${cfg.stateDir}/log4j2.xml";
        SOLR_LOGS_DIR = "${cfg.stateDir}/logs";
        SOLR_PORT = "${toString cfg.port}";
      };
      path = with pkgs; [
        gawk
        procps
      ];
      preStart = ''
        mkdir -p "${cfg.stateDir}/data";
        mkdir -p "${cfg.stateDir}/logs";

        if ! test -e "${cfg.stateDir}/data/solr.xml"; then
          install -D -m0640 ${cfg.package}/server/solr/solr.xml "${cfg.stateDir}/data/solr.xml"
          install -D -m0640 ${cfg.package}/server/solr/zoo.cfg "${cfg.stateDir}/data/zoo.cfg"
        fi

        if ! test -e "${cfg.stateDir}/log4j2.xml"; then
          install -D -m0640 ${cfg.package}/server/resources/log4j2.xml "${cfg.stateDir}/log4j2.xml"
        fi
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart="${cfg.package}/bin/solr start -f -a \"${concatStringsSep " " cfg.extraJavaOptions}\"";
        ExecStop="${cfg.package}/bin/solr stop";
      };
    };

    users.users = optionalAttrs (cfg.user == "solr") {
      solr = {
        group = cfg.group;
        home = cfg.stateDir;
        createHome = true;
        uid = config.ids.uids.solr;
      };
    };

    users.groups = optionalAttrs (cfg.group == "solr") {
      solr.gid = config.ids.gids.solr;
    };

  };

}
