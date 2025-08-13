# TODO: create a common module generator for Taler and Libeufin?
{
  talerComponent ? "",
  servicesDB ? [ ],
  servicesNoDB ? [ ],
  ...
}:
{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = cfgTaler.${talerComponent};
  cfgTaler = config.services.taler;

  settingsFormat = pkgs.formats.ini { };

  configFile = config.environment.etc."taler/taler.conf".source;
  componentConfigFile = settingsFormat.generate "generated-taler-${talerComponent}.conf" cfg.settings;

  services = servicesDB ++ servicesNoDB;

  dbName = "taler-${talerComponent}-httpd";
  groupName = "taler-${talerComponent}-services";

  inherit (cfgTaler) runtimeDir;
in
{
  options = {
    services.taler.${talerComponent} = {
      enable = lib.mkEnableOption "the GNU Taler ${talerComponent}";
      package = lib.mkPackageOption pkgs "taler-${talerComponent}" { };
      # TODO: make option accept multiple debugging levels?
      debug = lib.mkEnableOption "debug logging";
      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to open ports in the firewall";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.taler.enable = cfg.enable;
    services.taler.includes = [ componentConfigFile ];

    systemd.services = lib.mergeAttrsList [
      # Main services
      (lib.genAttrs (map (n: "taler-${talerComponent}-${n}") services) (name: {
        serviceConfig = {
          DynamicUser = true;
          User = dbName;
          Group = groupName;
          ExecStart = toString [
            (lib.getExe' cfg.package name)
            "-c ${configFile}"
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
        documentation = [
          "man:taler-${talerComponent}-${name}(1)"
          "info:taler-${talerComponent}"
        ];
      }))
      # Database Initialisation
      {
        "taler-${talerComponent}-dbinit" = {
          path = [ config.services.postgresql.package ];
          documentation = [
            "man:taler-${talerComponent}-dbinit(1)"
            "info:taler-${talerComponent}"
          ];
          serviceConfig = {
            Type = "oneshot";
            DynamicUser = true;
            User = dbName;
            Group = groupName;
            Restart = "on-failure";
            RestartSec = "5s";
          };
          requires = [ "postgresql.target" ];
          after = [ "postgresql.target" ];
        };
      }
    ];

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

    services.postgresql = {
      enable = true;
      ensureDatabases = [ dbName ];
      ensureUsers = [
        {
          name = dbName;
          ensureDBOwnership = true;
        }
      ];
    };
  };
}
