{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.services.hardware.openrgb;
in {
  options.services.hardware.openrgb = {
    enable = mkEnableOption (lib.mdDoc "OpenRGB server");

    package = mkPackageOption pkgs "openrgb" { };

    motherboard = mkOption {
      type = types.nullOr (types.enum [ "amd" "intel" ]);
      default = if config.hardware.cpu.intel.updateMicrocode then "intel"
        else if config.hardware.cpu.amd.updateMicrocode then "amd"
        else null;
      defaultText = literalMD ''
        if config.hardware.cpu.intel.updateMicrocode then "intel"
        else if config.hardware.cpu.amd.updateMicrocode then "amd"
        else null;
      '';
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
     ++ lib.optionals (cfg.motherboard == "amd") [ "i2c-piix4" ]
     ++ lib.optionals (cfg.motherboard == "intel") [ "i2c-i801" ];

    systemd.services.openrgb = {
      description = "OpenRGB server daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        StateDirectory = "OpenRGB";
        WorkingDirectory = "/var/lib/OpenRGB";
        ExecStart = "${cfg.package}/bin/openrgb --server --server-port ${toString cfg.server.port}";
        Restart = "always";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ jonringer ];
}
