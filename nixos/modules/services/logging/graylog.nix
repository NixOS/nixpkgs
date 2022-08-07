{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.graylog;

  confFile = pkgs.writeText "graylog.conf" ''
    is_master = ${boolToString cfg.isMaster}
    node_id_file = ${cfg.nodeIdFile}
    password_secret = ${cfg.passwordSecret}
    root_username = ${cfg.rootUsername}
    root_password_sha2 = ${cfg.rootPasswordSha2}
    elasticsearch_hosts = ${concatStringsSep "," cfg.elasticsearchHosts}
    message_journal_dir = ${cfg.messageJournalDir}
    mongodb_uri = ${cfg.mongodbUri}
    plugin_dir = /var/lib/graylog/plugins

    ${cfg.extraConfig}
  '';

  glPlugins = pkgs.buildEnv {
    name = "graylog-plugins";
    paths = cfg.plugins;
  };

in

{
  ###### interface

  options = {

    services.graylog = {

      enable = mkEnableOption "Graylog";

      package = mkOption {
        type = types.package;
        default = pkgs.graylog;
        defaultText = literalExpression "pkgs.graylog";
        description = lib.mdDoc "Graylog package to use.";
      };

      user = mkOption {
        type = types.str;
        default = "graylog";
        description = lib.mdDoc "User account under which graylog runs";
      };

      isMaster = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc "Whether this is the master instance of your Graylog cluster";
      };

      nodeIdFile = mkOption {
        type = types.str;
        default = "/var/lib/graylog/server/node-id";
        description = lib.mdDoc "Path of the file containing the graylog node-id";
      };

      passwordSecret = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          You MUST set a secret to secure/pepper the stored user passwords here. Use at least 64 characters.
          Generate one by using for example: pwgen -N 1 -s 96
        '';
      };

      rootUsername = mkOption {
        type = types.str;
        default = "admin";
        description = lib.mdDoc "Name of the default administrator user";
      };

      rootPasswordSha2 = mkOption {
        type = types.str;
        example = "e3c652f0ba0b4801205814f8b6bc49672c4c74e25b497770bb89b22cdeb4e952";
        description = lib.mdDoc ''
          You MUST specify a hash password for the root user (which you only need to initially set up the
          system and in case you lose connectivity to your authentication backend)
          This password cannot be changed using the API or via the web interface. If you need to change it,
          modify it here.
          Create one by using for example: echo -n yourpassword | shasum -a 256
          and use the resulting hash value as string for the option
        '';
      };

      elasticsearchHosts = mkOption {
        type = types.listOf types.str;
        example = literalExpression ''[ "http://node1:9200" "http://user:password@node2:19200" ]'';
        description = lib.mdDoc "List of valid URIs of the http ports of your elastic nodes. If one or more of your elasticsearch hosts require authentication, include the credentials in each node URI that requires authentication";
      };

      messageJournalDir = mkOption {
        type = types.str;
        default = "/var/lib/graylog/data/journal";
        description = lib.mdDoc "The directory which will be used to store the message journal. The directory must be exclusively used by Graylog and must not contain any other files than the ones created by Graylog itself";
      };

      mongodbUri = mkOption {
        type = types.str;
        default = "mongodb://localhost/graylog";
        description = lib.mdDoc "MongoDB connection string. See http://docs.mongodb.org/manual/reference/connection-string/ for details";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc "Any other configuration options you might want to add";
      };

      plugins = mkOption {
        description = lib.mdDoc "Extra graylog plugins";
        default = [ ];
        type = types.listOf types.package;
      };

    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    users.users = mkIf (cfg.user == "graylog") {
      graylog = {
        isSystemUser = true;
        group = "graylog";
        description = "Graylog server daemon user";
      };
    };
    users.groups = mkIf (cfg.user == "graylog") { graylog = {}; };

    systemd.tmpfiles.rules = [
      "d '${cfg.messageJournalDir}' - ${cfg.user} - - -"
    ];

    systemd.services.graylog = {
      description = "Graylog Server";
      wantedBy = [ "multi-user.target" ];
      environment = {
        GRAYLOG_CONF = "${confFile}";
      };
      path = [ pkgs.which pkgs.procps ];
      preStart = ''
        rm -rf /var/lib/graylog/plugins || true
        mkdir -p /var/lib/graylog/plugins -m 755

        mkdir -p "$(dirname ${cfg.nodeIdFile})"
        chown -R ${cfg.user} "$(dirname ${cfg.nodeIdFile})"

        for declarativeplugin in `ls ${glPlugins}/bin/`; do
          ln -sf ${glPlugins}/bin/$declarativeplugin /var/lib/graylog/plugins/$declarativeplugin
        done
        for includedplugin in `ls ${cfg.package}/plugin/`; do
          ln -s ${cfg.package}/plugin/$includedplugin /var/lib/graylog/plugins/$includedplugin || true
        done
      '';
      serviceConfig = {
        User="${cfg.user}";
        StateDirectory = "graylog";
        ExecStart = "${cfg.package}/bin/graylogctl run";
      };
    };
  };
}
