{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.linux-enable-ir-emitter;
in
{
  options = {
    services.linux-enable-ir-emitter = {
      enable = lib.mkEnableOption "" // {
        description = ''
          Whether to enable IR emitter hardware. Designed to be used with the
          Howdy facial authentication. After enabling the service, configure
          the emitter with `sudo linux-enable-ir-emitter configure`.
        '';
      };

      package = lib.mkPackageOption pkgs "linux-enable-ir-emitter" { } // {
        description = ''
          Package to use for the Linux Enable IR Emitter service.
        '';
      };

      device = lib.mkOption {
        type = lib.types.str;
        default = "video2";
        description = ''
          IR camera device to depend on. For example, for `/dev/video2`
          the value would be `video2`. Find this with the command
          {command}`realpath /dev/v4l/by-path/<generated-driver-name>`.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # https://github.com/EmixamPP/linux-enable-ir-emitter/blob/7e3a6527ef2efccabaeefc5a93c792628325a8db/sources/systemd/linux-enable-ir-emitter.service
    systemd.services.linux-enable-ir-emitter =
      let
        targets = [
          "suspend.target"
          "sleep.target"
          "hybrid-sleep.target"
          "hibernate.target"
          "suspend-then-hibernate.target"
        ];
      in
      {
        description = "Enable the infrared emitter";
        # Added to match
        # https://github.com/EmixamPP/linux-enable-ir-emitter/blob/6.1.2/boot_service/systemd/linux-enable-ir-emitter.service
        # Prevents the program fail to detect the IR camera until a service
        # restart.
        preStart = ''
          ${pkgs.kmod}/bin/modprobe uvcvideo
          sleep 1
        '';
        script = "${lib.getExe cfg.package} --verbose run";
        serviceConfig.StateDirectory = "linux-enable-ir-emitter";
        serviceConfig.LogsDirectory = "linux-enable-ir-emitter";

        wantedBy = targets ++ [ "multi-user.target" ];
        after = targets ++ [ "dev-${cfg.device}.device" ];
      };
  };
}
