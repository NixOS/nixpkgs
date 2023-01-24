{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.meilisearch;

in
{

  meta.maintainers = with maintainers; [ Br1ght0ne happysalada ];
  meta.doc = ./meilisearch.md;

  ###### interface

  options.services.meilisearch = {
    enable = mkEnableOption (lib.mdDoc "MeiliSearch - a RESTful search API");

    package = mkOption {
      description = lib.mdDoc "The package to use for meilisearch. Use this if you require specific features to be enabled. The default package has no features.";
      default = pkgs.meilisearch;
      defaultText = lib.literalExpression "pkgs.meilisearch";
      type = types.package;
    };

    listenAddress = mkOption {
      description = lib.mdDoc "MeiliSearch listen address.";
      default = "127.0.0.1";
      type = types.str;
    };

    listenPort = mkOption {
      description = lib.mdDoc "MeiliSearch port to listen on.";
      default = 7700;
      type = types.port;
    };

    environment = mkOption {
      description = lib.mdDoc "Defines the running environment of MeiliSearch.";
      default = "development";
      type = types.enum [ "development" "production" ];
    };

    # TODO change this to LoadCredentials once possible
    masterKeyEnvironmentFile = mkOption {
      description = lib.mdDoc ''
        Path to file which contains the master key.
        By doing so, all routes will be protected and will require a key to be accessed.
        If no master key is provided, all routes can be accessed without requiring any key.
        The format is the following:
        MEILI_MASTER_KEY=my_secret_key
      '';
      default = null;
      type = with types; nullOr path;
    };

    noAnalytics = mkOption {
      description = lib.mdDoc ''
        Deactivates analytics.
        Analytics allow MeiliSearch to know how many users are using MeiliSearch,
        which versions and which platforms are used.
        This process is entirely anonymous.
      '';
      default = true;
      type = types.bool;
    };

    logLevel = mkOption {
      description = lib.mdDoc ''
        Defines how much detail should be present in MeiliSearch's logs.
        MeiliSearch currently supports four log levels, listed in order of increasing verbosity:
        - 'ERROR': only log unexpected events indicating MeiliSearch is not functioning as expected
        - 'WARN:' log all unexpected events, regardless of their severity
        - 'INFO:' log all events. This is the default value
        - 'DEBUG': log all events and including detailed information on MeiliSearch's internal processes.
          Useful when diagnosing issues and debugging
      '';
      default = "INFO";
      type = types.str;
    };

    maxIndexSize = mkOption {
      description = lib.mdDoc ''
        Sets the maximum size of the index.
        Value must be given in bytes or explicitly stating a base unit.
        For example, the default value can be written as 107374182400, '107.7Gb', or '107374 Mb'.
        Default is 100 GiB
      '';
      default = "107374182400";
      type = types.str;
    };

    payloadSizeLimit = mkOption {
      description = lib.mdDoc ''
        Sets the maximum size of accepted JSON payloads.
        Value must be given in bytes or explicitly stating a base unit.
        For example, the default value can be written as 107374182400, '107.7Gb', or '107374 Mb'.
        Default is ~ 100 MB
      '';
      default = "104857600";
      type = types.str;
    };

  };

  ###### implementation

  config = mkIf cfg.enable {
    systemd.services.meilisearch = {
      description = "MeiliSearch daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = {
        MEILI_DB_PATH = "/var/lib/meilisearch";
        MEILI_HTTP_ADDR = "${cfg.listenAddress}:${toString cfg.listenPort}";
        MEILI_NO_ANALYTICS = toString cfg.noAnalytics;
        MEILI_ENV = cfg.environment;
        MEILI_DUMPS_DIR = "/var/lib/meilisearch/dumps";
        MEILI_LOG_LEVEL = cfg.logLevel;
        MEILI_MAX_INDEX_SIZE = cfg.maxIndexSize;
      };
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/meilisearch";
        DynamicUser = true;
        StateDirectory = "meilisearch";
        EnvironmentFile = mkIf (cfg.masterKeyEnvironmentFile != null) cfg.masterKeyEnvironmentFile;
      };
    };
  };
}
