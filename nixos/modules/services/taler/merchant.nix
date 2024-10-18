{
  lib,
  config,
  options,
  pkgs,
  ...
}:

let
  talerUtils = import ./utils.nix { inherit lib pkgs config; };

  cfg = cfgTaler.merchant;
  cfgTaler = config.services.taler;
in

talerUtils.mkTalerModule rec {
  talerComponent = "merchant";

  # https://docs.taler.net/taler-merchant-manual.html#launching-the-backend
  servicesDB = [
    "httpd"
    "webhook"
    "wirewatch"
    "depositcheck"
    "exchange"
  ];

  extraOptions = {
    services.taler.merchant = {
      settings = lib.mkOption {
        description = ''
          Configuration options for the taler merchant config file.

          For a list of all possible options, please see the man page [`taler.conf(5)`](https://docs.taler.net/manpages/taler.conf.5.html#merchant-options)
        '';
        type = lib.types.submodule {
          inherit (options.services.taler.settings.type.nestedTypes) freeformType;
          options = {
            # TODO: do we want this to be a sub-attribute or only define the merchant set of options here
            merchant = {
              DB = lib.mkOption {
                type = lib.types.str;
                internal = true;
                default = "postgres";
                description = "Plugin to use for the database.";
              };
              PORT = lib.mkOption {
                type = lib.types.port;
                default = 8083;
                description = "Port on which the HTTP server listens.";
              };
              SERVE = lib.mkOption {
                type = lib.types.str;
                default = "tcp";
                description = ''
                  Whether the HTTP server should listen on a UNIX domain socket ("unix") or on a TCP socket ("tcp").
                '';
              };
              LEGAL_PRESERVATION = lib.mkOption {
                type = lib.types.str;
                internal = true;
                default = "10 years";
                description = "How long to keep data in the database for tax audits after the transaction has completed.";
              };
            };
            merchantdb-postgres = {
              CONFIG = lib.mkOption {
                type = lib.types.str;
                internal = true;
                default = "postgres:///taler-${talerComponent}-httpd";
                description = "Database connection URI.";
              };
              SQL_DIR = lib.mkOption {
                type = lib.types.str;
                internal = true;
                default = "${cfg.package}/share/taler/sql/merchant/";
                description = "The location for the SQL files to setup the database tables.";
              };
            };
          };
        };
        default = { };
      };
    };
  };

  extraConfig = {
    systemd.services.taler-merchant-depositcheck = {
      # taler-merchant-depositcheck needs its executable is in the PATH
      # NOTE: couldn't use `lib.getExe` to only get that single executable
      path = [ cfg.package ];
    };
  };

  dbInit.script =
    let
      # NOTE: not documented, but is necessary
      dbScript = pkgs.writers.writeText "taler-merchant-db-permissions.sql" (
        lib.concatStrings (
          map (name: ''
            GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA merchant TO "taler-merchant-${name}";
            GRANT USAGE ON SCHEMA merchant TO "taler-merchant-${name}";
          '') servicesDB
        )
      );
    in
    ''
      ${lib.getExe' cfg.package "taler-merchant-dbinit"}
      psql -U taler-${talerComponent}-httpd -f ${dbScript}
    '';
}
