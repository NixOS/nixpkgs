{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.services.neondb;
  settingsFormat = pkgs.formats.toml {};
  argumentsFormat = pkgs.formats.shellArgs {disablePrefix = "disable-";};
  pageserverOpts = {config, ...}: {
    options = let
      name = config._module.args.name;
    in {
      settings = mkOption {
        description = ''
          Pageserver settings, converted and passed as TOML config file.
          Overriden by `configFile`.

          For available params, see: <https://github.com/neondatabase/neon/blob/master/docs/settings.md>
        '';
        type = types.submodule {
          freeformType = settingsFormat.type;
        };
      };
      configFile = mkOption {
        description = ''
          Pageserver config file.
          Overrides any values set using `settings`.
        '';
        type = types.path;
        default =
          settingsFormat.generate
          "pageserver-${name}.toml"
          config.settings;
        defaultText = literalMD "TOML file generated from {option}`services.neondb.pageservers.<pageserver>.settings`";
      };
    };
  };
  safekeeperOpts = {...}: {
    options = {
      settings = mkOption {
        description = ''
          Safekeeper settings, passed as arguments
        '';
        type = types.submodule {
          freeformType = argumentsFormat.type;
        };
      };
    };
  };
  generatePageserverUnit = name: pageserver:
    let
      identityFile = settingsFormat.generate "identity-${name}.toml" {
        id = pageserver.settings.id;
      };
    in {
      name = "neondb-pageserver@${name}";
      value = {
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          ExecStartPre = [
            "${pkgs.coreutils}/bin/ln -sf ${pageserver.configFile} ./pageserver.toml"
            "${pkgs.coreutils}/bin/ln -sf ${identityFile} ./identity.toml"
          ];
        };
        overrideStrategy = "asDropin";
      };
    };
  generateSafekeeperUnit = name: safekeeper: {
    name = "neondb-safekeeper@${name}";
    value = {
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/safekeeper -D . \
            ${argumentsFormat.generateSystemd safekeeper.settings}
        '';
      };
      overrideStrategy = "asDropin";
    };
  };
in {
  options.services.neondb = {
    dataDir = mkOption {
      description = ''
        Default parent directory for all neondb components.
      '';
      type = types.path;
      default = "/var/lib/neondb";
    };
    pageservers = mkOption {
      description = "Neondb pageservers.";
      default = {};
      type = with types; attrsOf (submodule pageserverOpts);
    };
    safekeepers = mkOption {
      description = "Neondb safekeepers.";
      default = {};
      type = with types; attrsOf (submodule safekeeperOpts);
    };
    storageController = {
      enable = mkEnableOption "NeonDB Storage Controller";
      settings = mkOption {
        description = ''
          Storage controller settings, passed as CLI arguments.
        '';
        type = types.submodule {
          freeformType = argumentsFormat.type;
        };
        default = {};
      };
    };
    package = mkPackageOption pkgs "neondb" {};
    storageBrokerListenAddr = mkOption {
      description = "Listen address for the storage broker.";
      type = types.str;
      default = "127.0.0.1:50051";
    };
  };
  config = mkIf (cfg.pageservers != {} || cfg.safekeepers != {} || cfg.storageController.enable) {
    systemd.services =
      {
        "neondb-pageserver@" = {
          description = "NeonDB Pageserver %I";
          after = ["network.target"];
          serviceConfig = {
            ExecStart = "${cfg.package}/bin/pageserver -D .";
            StateDirectory = "neondb/pageserver/%i";
            WorkingDirectory = "/var/lib/neondb/pageserver/%i";
            DynamicUser = true;
            Restart = "on-failure";
            RestartSec = 5;
          };
        };
        "neondb-safekeeper@" = {
          description = "NeonDB Safekeeper %I";
          after = ["network.target"];
          serviceConfig = {
            StateDirectory = "neondb/safekeeper/%i";
            WorkingDirectory = "/var/lib/neondb/safekeeper/%i";
            DynamicUser = true;
            Restart = "on-failure";
            RestartSec = 5;
          };
        };
        "neondb-storage-broker" = {
          description = "NeonDB Storage Broker";
          after = ["network.target"];
          wantedBy = ["multi-user.target"];
          serviceConfig = {
            ExecStart = "${cfg.package}/bin/storage_broker --listen-addr ${cfg.storageBrokerListenAddr}";
            StateDirectory = "neondb/storage-broker";
            WorkingDirectory = "/var/lib/neondb/storage-broker";
            DynamicUser = true;
            Restart = "on-failure";
            RestartSec = 5;
          };
        };
      }
      // (mapAttrs' generatePageserverUnit cfg.pageservers)
      // (mapAttrs' generateSafekeeperUnit cfg.safekeepers)
      // optionalAttrs cfg.storageController.enable {
        "neondb-storage-controller" = {
          description = "NeonDB Storage Controller";
          after = ["network.target" "postgresql.service"];
          requires = ["postgresql.service"];
          wantedBy = ["multi-user.target"];
          serviceConfig = {
            ExecStart = ''
              ${cfg.package}/bin/storage_controller \
                ${argumentsFormat.generateSystemd cfg.storageController.settings}
            '';
            StateDirectory = "neondb/storage-controller";
            WorkingDirectory = "/var/lib/neondb/storage-controller";
            DynamicUser = true;
            Restart = "on-failure";
            RestartSec = 5;
          };
        };
      };
  };
}
