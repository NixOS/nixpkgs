{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.meilisearch;

in {

  meta.maintainers = with maintainers; [ filalex77 ];

  ###### interface

  options.services.meilisearch = {
    enable = mkEnableOption "MeiliSearch - a RESTful search API";

    listenAddress = mkOption {
      description = "MeiliSearch listen address.";
      default = "127.0.0.1";
      type = types.str;
    };

    listenPort = mkOption {
      description = "MeiliSearch port to listen on.";
      default = 7700;
      type = types.port;
    };

    environment = mkOption {
      description = "Defines the running environment of MeiliSearch.";
      default = "development";
      type = types.enum [ "development" "production" ];
    };

    masterKeyFile = mkOption {
      description = ''
        Path to file which contains the master key.
        By doing so, all routes will be protected and will require a key to be accessed.
        If no master key is provided, all routes can be accessed without requiring any key.
      '';
      default = null;
      type = with types; nullOr path;
    };

    noAnalytics = mkOption {
      description = ''
        Deactivates analytics.
        Analytics allow MeiliSearch to know how many users are using MeiliSearch,
        which versions and which platforms are used.
        This process is entirely anonymous.
      '';
      default = false;
      type = types.bool;
    };

  };

  ###### implementation
  
  config = mkIf cfg.enable {
    systemd.services.meilisearch = {
      description = "MeiliSearch daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = let
        masterKey = mkIf (cfg.masterKeyFile != null) (builtins.readFile cfg.masterKeyFile);
      in {
        MEILI_DB_PATH = "/var/lib/meilisearch";
        MEILI_HTTP_ADDR = "${cfg.listenAddress}:${toString cfg.listenPort}";
        MEILI_MASTER_KEY = masterKey;
        MEILI_NO_ANALYTICS = toString cfg.noAnalytics;
        MEILI_ENV = cfg.environment;
      };
      serviceConfig = {
        ExecStart = "${pkgs.meilisearch}/bin/meilisearch";
        DynamicUser = true;
        StateDirectory = "meilisearch";
      };
    };

    environment.systemPackages = [ pkgs.meilisearch ];
  };
}
