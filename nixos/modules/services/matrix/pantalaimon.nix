{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.pantalaimon-headless;

  iniFmt = pkgs.formats.ini { };

  mkConfigFile = name: instanceConfig: iniFmt.generate "pantalaimon.conf" {
    Default = {
      LogLevel = instanceConfig.logLevel;
      Notifications = false;
    };

    ${name} = (recursiveUpdate
      {
        Homeserver = instanceConfig.homeserver;
        ListenAddress = instanceConfig.listenAddress;
        ListenPort = instanceConfig.listenPort;
        SSL = instanceConfig.ssl;

        # Set some settings to prevent user interaction for headless operation
        IgnoreVerification = true;
        UseKeyring = false;
      }
      instanceConfig.extraSettings
    );
  };

  mkPantalaimonService = name: instanceConfig:
    nameValuePair "pantalaimon-${name}" {
      description = "pantalaimon instance ${name} - E2EE aware proxy daemon for matrix clients";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = ''${pkgs.pantalaimon-headless}/bin/pantalaimon --config ${mkConfigFile name instanceConfig} --data-path ${instanceConfig.dataPath}'';
        Restart = "on-failure";
        DynamicUser = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        StateDirectory = "pantalaimon-${name}";
      };
    };
in
{
  options.services.pantalaimon-headless.instances = mkOption {
    default = { };
    type = types.attrsOf (types.submodule (import ./pantalaimon-options.nix));
    description = lib.mdDoc ''
      Declarative instance config.

      Note: to use pantalaimon interactively, e.g. for a Matrix client which does not
      support End-to-end encryption (like `fractal`), refer to the home-manager module.
    '';
  };

  config = mkIf (config.services.pantalaimon-headless.instances != { })
    {
      systemd.services = mapAttrs' mkPantalaimonService config.services.pantalaimon-headless.instances;
    };

  meta = {
    maintainers = with maintainers; [ jojosch ];
  };
}
