{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.meilisearch;

in
{

  meta.maintainers = with lib.maintainers; [
    Br1ght0ne
    happysalada
  ];
  meta.doc = ./meilisearch.md;

  ###### interface

  options.services.meilisearch = {
    enable = lib.mkEnableOption "MeiliSearch - a RESTful search API";

    package = lib.mkPackageOption pkgs "meilisearch" {
      extraDescription = ''
        Use this if you require specific features to be enabled. The default package has no features.
      '';
    };

    listenAddress = lib.mkOption {
      description = "MeiliSearch listen address.";
      default = "127.0.0.1";
      type = lib.types.str;
    };

    listenPort = lib.mkOption {
      description = "MeiliSearch port to listen on.";
      default = 7700;
      type = lib.types.port;
    };

    environment = lib.mkOption {
      description = "Defines the running environment of MeiliSearch.";
      default = "development";
      type = lib.types.enum [
        "development"
        "production"
      ];
    };

    # TODO change this to LoadCredentials once possible
    masterKeyEnvironmentFile = lib.mkOption {
      description = ''
        Path to file which contains the master key.
        By doing so, all routes will be protected and will require a key to be accessed.
        If no master key is provided, all routes can be accessed without requiring any key.
        The format is the following:
        MEILI_MASTER_KEY=my_secret_key
      '';
      default = null;
      type = with lib.types; nullOr path;
    };

    noAnalytics = lib.mkOption {
      description = ''
        Deactivates analytics.
        Analytics allow MeiliSearch to know how many users are using MeiliSearch,
        which versions and which platforms are used.
        This process is entirely anonymous.
      '';
      default = true;
      type = lib.types.bool;
    };

    logLevel = lib.mkOption {
      description = ''
        Defines how much detail should be present in MeiliSearch's logs.
        MeiliSearch currently supports four log levels, listed in order of increasing verbosity:
        - 'ERROR': only log unexpected events indicating MeiliSearch is not functioning as expected
        - 'WARN:' log all unexpected events, regardless of their severity
        - 'INFO:' log all events. This is the default value
        - 'DEBUG': log all events and including detailed information on MeiliSearch's internal processes.
          Useful when diagnosing issues and debugging
      '';
      default = "INFO";
      type = lib.types.str;
    };

    maxIndexSize = lib.mkOption {
      description = ''
        Sets the maximum size of the index.
        Value must be given in bytes or explicitly stating a base unit.
        For example, the default value can be written as 107374182400, '107.7Gb', or '107374 Mb'.
        Default is 100 GiB
      '';
      default = "107374182400";
      type = lib.types.str;
    };

    payloadSizeLimit = lib.mkOption {
      description = ''
        Sets the maximum size of accepted JSON payloads.
        Value must be given in bytes or explicitly stating a base unit.
        For example, the default value can be written as 107374182400, '107.7Gb', or '107374 Mb'.
        Default is ~ 100 MB
      '';
      default = "104857600";
      type = lib.types.str;
    };

    # TODO: turn on by default when it stops being experimental
    dumplessUpgrade = lib.mkOption {
      default = false;
      example = true;
      description = ''
        Whether to enable (experimental) dumpless upgrade.

        Allows upgrading from Meilisearch >=v1.12 to Meilisearch >=v1.13 without manually
        dumping and importing the database.

        More information at https://www.meilisearch.com/docs/learn/update_and_migration/updating#dumpless-upgrade
      '';
      type = lib.types.bool;
    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    warnings = lib.optional (lib.versionOlder cfg.package.version "1.12") ''
      Meilisearch 1.11 will be removed in NixOS 25.11. As it was the last
      version not to support dumpless upgrades, you will have to manually
      migrate your data before that. Instructions can be found at
      https://www.meilisearch.com/docs/learn/update_and_migration/updating#using-a-dump
      and afterwards, you can set `services.meilisearch.package = pkgs.meilisearch;`
      to use the latest version.
    '';

    services.meilisearch.package = lib.mkDefault (
      if lib.versionAtLeast config.system.stateVersion "25.05" then
        pkgs.meilisearch
      else
        pkgs.meilisearch_1_11
    );

    # used to restore dumps
    environment.systemPackages = [ cfg.package ];

    systemd.services.meilisearch = {
      description = "MeiliSearch daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = {
        MEILI_DB_PATH = "/var/lib/meilisearch";
        MEILI_HTTP_ADDR = "${cfg.listenAddress}:${toString cfg.listenPort}";
        MEILI_NO_ANALYTICS = lib.boolToString cfg.noAnalytics;
        MEILI_ENV = cfg.environment;
        MEILI_DUMP_DIR = "/var/lib/meilisearch/dumps";
        MEILI_LOG_LEVEL = cfg.logLevel;
        MEILI_MAX_INDEX_SIZE = cfg.maxIndexSize;
        MEILI_EXPERIMENTAL_DUMPLESS_UPGRADE = lib.boolToString cfg.dumplessUpgrade;
      };
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/meilisearch";
        DynamicUser = true;
        StateDirectory = "meilisearch";
        EnvironmentFile = lib.mkIf (cfg.masterKeyEnvironmentFile != null) cfg.masterKeyEnvironmentFile;
      };
    };
  };
}
