{ pkgs, lib, config, ... }:
let
  cfg = config.services.hardware.openrgb;
in {
  options.services.hardware.openrgb = {
    enable = lib.mkEnableOption "OpenRGB server, for RGB lighting control";

    package = lib.mkPackageOption pkgs "openrgb" { };

    motherboard = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "amd" "intel" ]);
      default = if config.hardware.cpu.intel.updateMicrocode then "intel"
        else if config.hardware.cpu.amd.updateMicrocode then "amd"
        else null;
      defaultText = lib.literalMD ''
        if config.hardware.cpu.intel.updateMicrocode then "intel"
        else if config.hardware.cpu.amd.updateMicrocode then "amd"
        else null;
      '';
      description = "CPU family of motherboard. Allows for addition motherboard i2c support.";
    };

    server.port = lib.mkOption {
      type = lib.types.port;
      default = 6742;
      description = "Set server port of openrgb.";
    };

  };

  config = lib.mkIf cfg.enable {
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

  meta.maintainers = [ ];
}
