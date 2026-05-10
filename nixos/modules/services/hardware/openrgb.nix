{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.services.hardware.openrgb;
in
{
  options.services.hardware.openrgb = {
    enable = lib.mkEnableOption "OpenRGB server, for RGB lighting control";

    package = lib.mkPackageOption pkgs "openrgb" { };

    motherboard = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "amd"
          "intel"
        ]
      );
      default =
        if config.hardware.cpu.intel.updateMicrocode then
          "intel"
        else if config.hardware.cpu.amd.updateMicrocode then
          "amd"
        else
          null;
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

    startupProfile = lib.mkOption {
      type = lib.types.nullOr (lib.types.str);
      default = null;
      description = "The profile file to load from \"/var/lib/OpenRGB\" at startup.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];

    boot.kernelModules = [
      "i2c-dev"
    ]
    ++ lib.optionals (cfg.motherboard == "amd") [ "i2c-piix4" ]
    ++ lib.optionals (cfg.motherboard == "intel") [ "i2c-i801" ];

    systemd.services.openrgb = {
      description = "OpenRGB SDK Server";
      after = [
        "network.target"
        "lm_sensors.service"
      ];
      wants = [ "dev-usb.device" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        StateDirectory = "OpenRGB";
        WorkingDirectory = "/var/lib/OpenRGB";
        ExecStart = lib.escapeShellArgs (
          [
            (lib.getExe cfg.package)
            "--server"
            "--server-port"
            cfg.server.port
          ]
          ++ lib.optionals (lib.isString cfg.startupProfile) [
            "--profile"
            cfg.startupProfile
          ]
        );
        Restart = "always";
      };
    };
  };

  meta.maintainers = [ ];
}
