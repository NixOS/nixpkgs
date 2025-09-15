{
  config,
  options,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;

  cfg = config.services.orthanc;
  opt = options.services.orthanc;

  settingsFormat = pkgs.formats.json { };
in
{
  options = {
    services.orthanc = {
      enable = lib.mkEnableOption "Orthanc server";
      package = lib.mkPackageOption pkgs "orthanc" { };

      stateDir = lib.mkOption {
        type = types.path;
        default = "/var/lib/orthanc";
        example = "/home/foo";
        description = "State directory of Orthanc.";
      };

      environment = lib.mkOption {
        type = types.attrsOf types.str;
        default = {
        };
        example = ''
          {
            ORTHANC_NAME = "Orthanc server";
          }
        '';
        description = ''
          Extra environment variables
          For more details see <https://orthanc.uclouvain.be/book/users/configuration.html>
        '';
      };

      environmentFile = lib.mkOption {
        description = ''
          Environment file to be passed to the systemd service.
          Useful for passing secrets to the service to prevent them from being
          world-readable in the Nix store.
        '';
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/var/lib/secrets/orthancSecrets";
      };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = settingsFormat.type;
        };
        default = {
          HttpPort = lib.mkDefault 8042;
          IndexDirectory = lib.mkDefault "/var/lib/orthanc/";
          StorageDirectory = lib.mkDefault "/var/lib/orthanc/";
        };
        example = {
          Name = "My Orthanc Server";
          HttpPort = 12345;
        };
        description = ''
          Configuration written to a json file that is read by orthanc.
          See <https://orthanc.uclouvain.be/book/index.html> for more.
        '';
      };

      openFirewall = lib.mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to open the firewall for Orthanc.
          This adds `services.orthanc.settings.HttpPort` to `networking.firewall.allowedTCPPorts`.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.orthanc.settings = opt.settings.default;

    systemd.services.orthanc = {
      description = "Orthanc is a lightweight, RESTful DICOM server for healthcare and medical research";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment = cfg.environment;

      serviceConfig =
        let
          config-json = settingsFormat.generate "orthanc-config.json" (cfg.settings);
        in
        {
          ExecStart = "${lib.getExe cfg.package} ${config-json}";
          EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
          WorkingDirectory = cfg.stateDir;
          BindReadOnlyPaths = [
            "-/etc/localtime"
          ];
          StateDirectory = "orthanc";
          RuntimeDirectory = "orthanc";
          RuntimeDirectoryMode = "0755";
          PrivateTmp = true;
          DynamicUser = true;
          DevicePolicy = "closed";
          LockPersonality = true;
          PrivateUsers = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectControlGroups = true;
          RestrictNamespaces = true;
          RestrictRealtime = true;
          SystemCallArchitectures = "native";
          UMask = "0077";
        };
    };

    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.settings.HttpPort ]; };

    # Orthanc requires /etc/localtime to be present
    time.timeZone = lib.mkDefault "UTC";
  };

  meta.maintainers = with lib.maintainers; [ ];
}
