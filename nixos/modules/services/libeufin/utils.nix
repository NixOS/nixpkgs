# TODO: create a common module generator for Taler and Libeufin?
{
  lib,
  pkgs,
  config,
  ...
}:
{
  mkLibeufinModule =
    {
      libeufinComponent ? "",
      extraServices ? [ ],
      extraOptions ? { },
      extraConfig ? { },
      ...
    }:
    let
      cfg = cfgMain.${libeufinComponent};
      cfgMain = config.services.libeufin;

      # TODO: make into options?
      serviceName = "libeufin-${libeufinComponent}";
      servicesGroup = "libeufin-services";

      isNexus = libeufinComponent == "nexus";

      # get database name from config
      # TODO: enforce that bank and nexus be in the same db?
      dbName =
        lib.removePrefix "postgresql:///"
          cfg.settings."libeufin-${libeufinComponent}db-postgres".CONFIG;
    in
    {
      options = lib.recursiveUpdate {
        services.libeufin.${libeufinComponent} = {
          enable = lib.mkEnableOption "libeufin core banking system and web interface";
          package = lib.mkPackageOption pkgs "libeufin" { };
          debug = lib.mkEnableOption "debug logging";
          openFirewall = lib.mkEnableOption "Open ports in the firewall";
        };
      } extraOptions;

      config = lib.mkIf cfg.enable (
        lib.recursiveUpdate {
          systemd.services = lib.mergeAttrsList (
            [
              # Main service
              {
                "${serviceName}" = {
                  serviceConfig = {
                    User = serviceName;
                    Group = servicesGroup;
                    StateDirectory = serviceName;
                    StateDirectoryMode = "0750";
                    ExecStart = toString [
                      (lib.getExe' cfg.package "libeufin-${libeufinComponent}")
                      "serve -c ${cfgMain.configFile}"
                      (lib.optionalString cfg.debug " -L debug")
                    ];
                  };
                  # bank's dbinit starts first, then nexus after
                  requires = [ "libeufin-nexus-dbinit.service" ];
                  after = [ "libeufin-nexus-dbinit.service" ];
                  wantedBy = [ "multi-user.target" ]; # TODO slice?
                  # Some accounts might need to be registered before the
                  # service starts, like the exchange when the bank's currency
                  # conversion is enabled.
                  preStart =
                    let
                      registerAccounts = lib.pipe cfg.initialAccounts [
                        (map (account: ''
                          ${lib.getExe' cfg.package "libeufin-bank"} create-account \
                              -c ${cfgMain.configFile} \
                              --username ${account.username} \
                              --password ${account.password} \
                              --name ${account.name} \
                              --payto_uri="payto://x-taler-bank/bank:8082/${account.username}?receiver-name=${account.name}" \
                              ${lib.optionalString (lib.toLower account.username == "exchange") "--exchange"}
                        ''))
                        (lib.concatStringsSep "\n")
                      ];
                    in
                    lib.mkIf (!isNexus) ''
                      # only register initial accounts once
                      if [ ! -e /var/lib/${serviceName}/init ]; then
                        ${registerAccounts}

                        touch /var/lib/${serviceName}/init
                        echo "Bank initialisation complete"
                      fi
                    '';
                };
              }
              # Database Initialisation
              {
                "${serviceName}-dbinit" =
                  let
                    # needed for currency conversion
                    dbScript = pkgs.writers.writeText "libeufin-nexus-db-permissions.sql" ''
                      GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA libeufin_nexus TO "${serviceName}";
                      GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA libeufin_bank TO "${serviceName}";
                      GRANT USAGE ON SCHEMA libeufin_nexus TO "${serviceName}";
                      GRANT USAGE ON SCHEMA libeufin_bank TO "${serviceName}";
                    '';

                    # the bank and nexus shouldn't initialise the database at the same time
                    serviceReq = if isNexus then [ "libeufin-bank-dbinit.service" ] else [ "postgresql.service" ];
                  in
                  {
                    path = [ config.services.postgresql.package ];
                    serviceConfig = {
                      Type = "oneshot";
                      DynamicUser = true;
                      User = dbName;
                      Restart = "on-failure";
                      RestartSec = "5s";
                    };
                    script = ''
                      ${lib.getExe' cfg.package "libeufin-${libeufinComponent}"} dbinit \
                        -c ${cfgMain.configFile} \
                        ${lib.optionalString cfg.debug "-L debug"}

                      psql -U ${dbName} -f ${dbScript}
                    '';
                    requires = serviceReq;
                    after = serviceReq;
                  };
              }
            ]
            ++ extraServices
          );

          users.groups.${servicesGroup} = { };
          users.users.${serviceName} = {
            createHome = false;
            isSystemUser = true;
            group = servicesGroup;
          };

          networking.firewall = lib.mkIf cfg.openFirewall {
            allowedTCPPorts = [
              cfg.settings."${if isNexus then "nexus-httpd" else "libeufin-bank"}".PORT
            ];
          };

          environment.systemPackages = [ cfg.package ];

          services.libeufin = {
            inherit (cfg) enable settings;
          };

          services.postgresql = {
            enable = true;
            ensureDatabases = [ dbName ];
            ensureUsers = [
              { name = serviceName; }
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
