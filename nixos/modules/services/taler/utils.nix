# TODO: create a common module generator for Taler and Libeufin?
{
  lib,
  pkgs,
  config,
  ...
}:
{
  mkTalerModule =
    {
      talerComponent ? "",
      servicesDB ? [ ],
      servicesNoDB ? [ ],
      dbInit ? { },
      extraServices ? [ ],
      extraOptions ? { },
      extraConfig ? { },
      ...
    }:
    let
      cfg = cfgTaler.${talerComponent};
      cfgTaler = config.services.taler;

      services = servicesDB ++ servicesNoDB;

      dbName = "taler-${talerComponent}-httpd";

      # TODO: add option to enable these when needed?
      groupName = "taler-${talerComponent}-services";
      inherit (cfgTaler) runtimeDir;
    in
    {
      options = lib.recursiveUpdate {
        services.taler.${talerComponent} = {
          enable = lib.mkEnableOption "the GNU Taler ${talerComponent}";
          package = lib.mkPackageOption pkgs "taler-${talerComponent}" { };
          # TODO: make option accept multiple debugging levels?
          debug = lib.mkEnableOption "debug logging";
          openFirewall = lib.mkEnableOption "Open ports in the firewall";
        };
      } extraOptions;

      config = lib.mkIf cfg.enable (
        lib.recursiveUpdate {
          systemd.services = lib.mergeAttrsList (
            [
              # Main services
              (lib.genAttrs (map (n: "taler-${talerComponent}-${n}") services) (name: {
                serviceConfig = {
                  DynamicUser = true;
                  User = name;
                  Group = groupName;
                  ExecStart = toString [
                    (lib.getExe' cfg.package name)
                    "-c ${cfgTaler.configFile}"
                    (lib.optionalString cfg.debug " -L debug")
                  ];
                  RuntimeDirectory = name;
                  StateDirectory = name;
                  CacheDirectory = name;
                  ReadWritePaths = [ runtimeDir ];
                  Restart = "always";
                  RestartSec = "10s";
                };
                requires = [ "taler-${talerComponent}-dbinit.service" ];
                after = [ "taler-${talerComponent}-dbinit.service" ];
                wantedBy = [ "multi-user.target" ]; # TODO slice?
              }))
              # Database Initialisation
              (lib.optionalAttrs (dbInit ? script) {
                "taler-${talerComponent}-dbinit" = {
                  path = [ config.services.postgresql.package ] ++ (lib.optionals (dbInit ? path) dbInit.path);
                  serviceConfig = {
                    Type = "oneshot";
                    DynamicUser = true;
                    User = dbName;
                    Restart = "on-failure";
                    RestartSec = "5s";
                  };
                  inherit (dbInit) script;
                  requires = [ "postgresql.service" ];
                  after = [ "postgresql.service" ];
                };
              })
            ]
            ++ extraServices
          );

          users.groups.${groupName} = { };

          systemd.tmpfiles.settings = {
            "10-taler-${talerComponent}" = {
              "${runtimeDir}" = {
                d = {
                  group = groupName;
                  user = "nobody";
                  mode = "070";
                };
              };
            };
          };

          networking.firewall = lib.mkIf cfg.openFirewall {
            allowedTCPPorts = [ cfg.settings."${talerComponent}".PORT ];
          };

          environment.systemPackages = [ cfg.package ];

          # TODO: separate config file for each component and import them in Taler's main config?
          services.taler = {
            inherit (cfg) enable settings;
          };

          services.postgresql = {
            enable = true;
            ensureDatabases = [ dbName ];
            ensureUsers = map (service: { name = "taler-${talerComponent}-${service}"; }) servicesDB ++ [
              {
                name = dbName;
                ensureDBOwnership = true;
              }
            ];
          };
        } extraConfig
      );
    };
}
