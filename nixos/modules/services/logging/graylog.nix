{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.graylog;

  settings-ini = pkgs.writeText "graylog.conf" (
    lib.generators.toINIWithGlobalSection { listsAsDuplicateKeys = true; } {
      globalSection = cfg.settings;
    }
  );

  glPlugins = pkgs.buildEnv {
    name = "graylog-plugins";
    paths = cfg.plugins;
  };

in
{
  options.services.graylog = {
    enable = lib.mkEnableOption "Graylog, a log management solution.";
    package = lib.mkPackageOption pkgs "graylog" { };

    enableLocalMongoDB = lib.mkEnableOption "a local MongoDB instance.";

    settings = lib.mkOption {
      default = { };
      type = lib.types.submodule {
        freeformType = lib.types.anything;
        options = {
          is_master = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether this is the master instance of your Graylog cluster.";
          };

          node_id_file = lib.mkOption {
            type = lib.types.str;
            default = "/var/lib/graylog/server/node-id";
            description = "Path of the file containing the graylog node-id.";
          };

          root_username = lib.mkOption {
            type = lib.types.str;
            default = "admin";
            description = "Name of the default administrator user.";
          };

          message_journal_dir = lib.mkOption {
            type = lib.types.str;
            default = "/var/lib/graylog/data/journal";
            description = ''
              The directory which will be used to store the message journal.
              The directory must be exclusively used by Graylog and must not contain
              any other files than the ones created by Graylog itself.
            '';
          };

          plugin_dir = lib.mkOption {
            type = lib.types.str;
            default = "/var/lib/graylog/plugins";
            description = "Directory used to store Graylog server plugins.";
          };

          data_dir = lib.mkOption {
            type = lib.types.str;
            default = "/var/lib/graylog/data";
            description = "Directory used to store Graylog server state.";
          };

          mongodb_uri = lib.mkOption {
            type = lib.types.str;
            default = "mongodb://127.0.0.1:27017/graylog";
            description = ''
              MongoDB connection string.
              See http://docs.mongodb.org/manual/reference/connection-string/ for details.
            '';
          };

        };
      };
      example = {
        is_master = true;
        http_bind_address = "127.0.0.1:9000";
        http_external_uri = "http://127.0.0.1:9000/";
        mongodb_uri = "mongodb://127.0.0.1:27017/graylog";
      };
      description = ''
        Configuration for Graylog, as a structured Nix attribute set.

        If you specify settings here, they will be used as persistent
        configuration and Graylog will retain the same configuration
        across restarts.

        For a complete list of available options, see:
        https://go2docs.graylog.org/current/setting_up_graylog/server_configuration_settings_reference.htm
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "graylog";
      description = "User account under which graylog runs.";
    };

    passwordSecretFile = lib.mkOption {
      type = lib.types.path;
      description = ''
        Path of the file containing the secret to secure/pepper the stored user passwords here.

        You MUST set a secret here. Use at least 64 characters.
        Generate one by using for example: pwgen -N 1 -s 96
      '';
    };

    rootPasswordSha2File = lib.mkOption {
      type = lib.types.path;
      description = ''
        Path of the file containing a hash password for the root user.

        You MUST specify a hash password for the root user (which you only need
        to initially set up the system and in case you lose connectivity to your
        authentication backend). This password cannot be changed using the API
        or via the web interface. If you need to change it, modify it here.

        Create one by using for example: echo -n yourpassword | shasum -a 256
        and use the resulting hash value as string for the option.
      '';
    };

    elasticsearchHosts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      example = lib.literalExpression ''[ "http://node1:9200" "http://user:password@node2:19200" ]'';
      description = ''
        List of valid URIs of the http ports of your elastic nodes. If one or more
        of your elasticsearch hosts require authentication, include the credentials
        in each node URI that requires authentication.
      '';
    };

    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Extra graylog plugins.";
    };

  };

  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "graylog" "isMaster" ]
      [ "services" "graylog" "settings" "is_master" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "graylog" "nodeIdFile" ]
      [ "services" "graylog" "settings" "node_id_file" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "graylog" "rootUsername" ]
      [ "services" "graylog" "settings" "root_username" ]
    )
    (lib.mkRemovedOptionModule [
      "services"
      "graylog"
      "passwordSecret"
    ] "Please instead use `services.graylog.passwordSecretFile`")
    (lib.mkRemovedOptionModule [
      "services"
      "graylog"
      "rootPasswordSha2"
    ] "Please instead use `services.graylog.rootPasswordSha2File`")
    (lib.mkRenamedOptionModule
      [ "services" "graylog" "dataDir" ]
      [ "services" "graylog" "settings" "data_dir" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "graylog" "messageJournalDir" ]
      [ "services" "graylog" "settings" "message_journal_dir" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "graylog" "mongodbUri" ]
      [ "services" "graylog" "settings" "mongodb_uri" ]
    )
    (lib.mkRemovedOptionModule [
      "services"
      "graylog"
      "extraConfig"
    ] "Please instead use `services.graylog.settings`")
  ];

  config = lib.mkIf cfg.enable {
    services.graylog.settings.elasticsearch_hosts = lib.concatStringsSep "," cfg.elasticsearchHosts;

    services.mongodb = lib.mkIf cfg.enableLocalMongoDB {
      enable = true;
    };

    users.users = lib.mkIf (cfg.user == "graylog") {
      graylog = {
        isSystemUser = true;
        group = "graylog";
        description = "Graylog server daemon user";
      };
    };
    users.groups = lib.mkIf (cfg.user == "graylog") { graylog = { }; };

    systemd.tmpfiles.rules = [
      "d '${cfg.settings.message_journal_dir}' - ${cfg.user} - - -"
    ];

    systemd.services.graylog = {
      description = "Graylog Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ] ++ lib.optionals cfg.enableLocalMongoDB [ "mongodb.service" ];
      environment.GRAYLOG_CONF = "${settings-ini}";
      path = [
        pkgs.which
        pkgs.procps
      ];
      preStart = ''
        rm -rf /var/lib/graylog/plugins || true
        mkdir -p /var/lib/graylog/plugins -m 755

        mkdir -p "$(dirname ${cfg.settings.node_id_file})"
        chown -R ${cfg.user} "$(dirname ${cfg.settings.node_id_file})"

        for declarativeplugin in `ls ${glPlugins}/bin/`; do
          ln -sf ${glPlugins}/bin/$declarativeplugin /var/lib/graylog/plugins/$declarativeplugin
        done
        for includedplugin in `ls ${cfg.package}/plugin/`; do
          ln -s ${cfg.package}/plugin/$includedplugin /var/lib/graylog/plugins/$includedplugin || true
        done
      '';
      serviceConfig = {
        LoadCredential = [
          "passwordSecret:${cfg.passwordSecretFile}"
          "rootSha2:${cfg.rootPasswordSha2File}"
        ];
        User = "${cfg.user}";
        StateDirectory = "graylog";
      };
      script = ''
        set -eou pipefail
        shopt -s inherit_errexit

        GRAYLOG_PASSWORD_SECRET="$(<"$CREDENTIALS_DIRECTORY/passwordSecret")" \
        GRAYLOG_ROOT_PASSWORD_SHA2="$(<"$CREDENTIALS_DIRECTORY/rootSha2")" \
        ${cfg.package}/bin/graylogctl run
      '';
    };
  };
}
