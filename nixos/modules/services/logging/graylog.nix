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
    elasticsearch_cluster_name = ${cfg.elasticsearchClusterName}
    elasticsearch_discovery_zen_ping_multicast_enabled = ${boolToString cfg.elasticsearchDiscoveryZenPingMulticastEnabled}
    elasticsearch_discovery_zen_ping_unicast_hosts = ${cfg.elasticsearchDiscoveryZenPingUnicastHosts}
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
        defaultText = "pkgs.graylog";
        example = literalExample "pkgs.graylog";
        description = "Graylog package to use.";
      };

      user = mkOption {
        type = types.str;
        default = "graylog";
        example = literalExample "graylog";
        description = "User account under which graylog runs";
      };

      isMaster = mkOption {
        type = types.bool;
        default = true;
        description = "Whether this is the master instance of your Graylog cluster";
      };

      nodeIdFile = mkOption {
        type = types.str;
        default = "/var/lib/graylog/server/node-id";
        description = "Path of the file containing the graylog node-id";
      };

      passwordSecret = mkOption {
        type = types.str;
        description = ''
          You MUST set a secret to secure/pepper the stored user passwords here. Use at least 64 characters.
          Generate one by using for example: pwgen -N 1 -s 96
        '';
      };

      rootUsername = mkOption {
        type = types.str;
        default = "admin";
        description = "Name of the default administrator user";
      };

      rootPasswordSha2 = mkOption {
        type = types.str;
        example = "e3c652f0ba0b4801205814f8b6bc49672c4c74e25b497770bb89b22cdeb4e952";
        description = ''
          You MUST specify a hash password for the root user (which you only need to initially set up the
          system and in case you lose connectivity to your authentication backend)
          This password cannot be changed using the API or via the web interface. If you need to change it,
          modify it here.
          Create one by using for example: echo -n yourpassword | shasum -a 256
          and use the resulting hash value as string for the option
        '';
      };

      elasticsearchClusterName = mkOption {
        type = types.str;
        example = "graylog";
        description = "This must be the same as for your Elasticsearch cluster";
      };

      elasticsearchDiscoveryZenPingMulticastEnabled = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to use elasticsearch multicast discovery";
      };

      elasticsearchDiscoveryZenPingUnicastHosts = mkOption {
        type = types.str;
        default = "127.0.0.1:9300";
        description = "Tells Graylogs Elasticsearch client how to find other cluster members. See Elasticsearch documentation for details";
      };

      messageJournalDir = mkOption {
        type = types.str;
        default = "/var/lib/graylog/data/journal";
        description = "The directory which will be used to store the message journal. The directory must be exclusively used by Graylog and must not contain any other files than the ones created by Graylog itself";
      };

      mongodbUri = mkOption {
        type = types.str;
        default = "mongodb://localhost/graylog";
        description = "MongoDB connection string. See http://docs.mongodb.org/manual/reference/connection-string/ for details";
      };

      extraConfig = mkOption {
        type = types.str;
        default = "";
        description = "Any other configuration options you might want to add";
      };

      plugins = mkOption {
        description = "Extra graylog plugins";
        default = [ ];
        type = types.listOf types.package;
      };

    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    users.extraUsers = mkIf (cfg.user == "graylog") {
      graylog = {
        uid = config.ids.uids.graylog;
        description = "Graylog server daemon user";
      };
    };

    systemd.services.graylog = with pkgs; {
      description = "Graylog Server";
      wantedBy = [ "multi-user.target" ];
      environment = {
        JAVA_HOME = jre;
        GRAYLOG_CONF = "${confFile}";
      };
      path = [ pkgs.openjdk8 pkgs.which pkgs.procps ];
      preStart = ''
        mkdir -p /var/lib/graylog -m 755

        rm -rf /var/lib/graylog/plugins || true
        mkdir -p /var/lib/graylog/plugins -m 755

        for declarativeplugin in `ls ${glPlugins}/bin/`; do
          ln -sf ${glPlugins}/bin/$declarativeplugin /var/lib/graylog/plugins/$declarativeplugin
        done
        for includedplugin in `ls ${cfg.package}/plugin/`; do
          ln -s ${cfg.package}/plugin/$includedplugin /var/lib/graylog/plugins/$includedplugin || true
        done
        chown -R ${cfg.user} /var/lib/graylog

        mkdir -p ${cfg.messageJournalDir} -m 755
        chown -R ${cfg.user} ${cfg.messageJournalDir}
      '';
      serviceConfig = {
        User="${cfg.user}";
        PermissionsStartOnly=true;
        ExecStart = "${cfg.package}/bin/graylogctl run";
      };
    };
  };
}
