{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.acpilight;
in
{
  options = {
    hardware.acpilight = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to enable acpilight.
          This will allow brightness control via the supplied xbacklight binary from users in the video group. Contrary to what the name suggests, this *will* work without a running X server.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ acpilight ];
    services.udev.packages = with pkgs; [ acpilight ];
  };
}
