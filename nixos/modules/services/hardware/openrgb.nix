{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.services.hardware.openrgb;
in {
  options.services.hardware.openrgb = {
    enable = mkEnableOption (lib.mdDoc "OpenRGB server");

    package = mkOption {
      type = types.package;
      default = pkgs.openrgb;
      defaultText = literalMD "pkgs.openrgb";
      description = lib.mdDoc "Set version of openrgb package to use.";
    };

    motherboard = mkOption {
      type = types.nullOr (types.enum [ "amd" "intel" ]);
      default = null;
      description = lib.mdDoc "CPU family of motherboard. Allows for addition motherboard i2c support.";
    };

    server.port = mkOption {
      type = types.port;
      default = 6742;
      description = lib.mdDoc "Set server port of openrgb.";
    };

  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];

    boot.kernelModules = [ "i2c-dev" ]
     ++ lib.optionals (cfg.motherboard == "amd") [ "i2c-piix" ]
     ++ lib.optionals (cfg.motherboard == "intel") [ "i2c-i801" ];

    systemd.services.openrgb = {
      description = "OpenRGB server daemon";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/openrgb --server --server-port ${toString cfg.server.port}";
        Restart = "always";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ jonringer ];
}
