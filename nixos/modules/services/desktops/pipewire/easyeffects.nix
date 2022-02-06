{ config, lib, pkgs, ... }:

let
  cfg = config.services.pipewire.easyeffects;
in
{
  meta.maintainers = with lib.maintainers; [ starcraft66 ];

  options = {
    services.pipewire.easyeffects = {
      enable = lib.mkEnableOption "Audio effects for PipeWire applications.";

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.easyeffects;
        defaultText = lib.literalExpression "pkgs.easyeffects";
        description = ''
          The easyeffects derivation to use.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.services.pipewire.enable && !config.hardware.pulseaudio.enable;
        message = "Easyeffects requires Pipewire to be enabled and is not compatible with PulseAudio.";
      }
    ];

    environment.systemPackages = [ cfg.package ];
    systemd.packages = [ cfg.package ];

    systemd.user.services.easyeffects = {
      wantedBy = [ "pipewire.service" ];
      serviceConfig = {
        Type = "dbus";
        BusName = "com.github.wwmm.easyeffects";
        ExecStart = "${cfg.package}/bin/easyeffects --gapplication-service";
        Restart = "always";
      };
    };
  };
}
