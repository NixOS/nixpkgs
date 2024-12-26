{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.infnoise;
in
{
  options = {
    services.infnoise = {
      enable = mkEnableOption "the Infinite Noise TRNG driver";

      fillDevRandom = mkOption {
        description = ''
          Whether to run the infnoise driver as a daemon to refill /dev/random.

          If disabled, you can use the `infnoise` command-line tool to
          manually obtain randomness.
        '';
        type = types.bool;
        default = true;
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.infnoise ];

    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6015", SYMLINK+="infnoise", TAG+="systemd", GROUP="dialout", MODE="0664", ENV{SYSTEMD_WANTS}="infnoise.service"
    '';

    systemd.services.infnoise = mkIf cfg.fillDevRandom {
      description = "Infinite Noise TRNG driver";

      bindsTo = [ "dev-infnoise.device" ];
      after = [ "dev-infnoise.device" ];

      serviceConfig = {
        ExecStart = "${pkgs.infnoise}/bin/infnoise --dev-random --debug";
        Restart = "always";
        User = "infnoise";
        DynamicUser = true;
        SupplementaryGroups = [ "dialout" ];
        DeviceAllow = [ "/dev/infnoise" ];
        DevicePolicy = "closed";
        PrivateNetwork = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true; # only reads entropy pool size and watermark
        RestrictNamespaces = true;
        RestrictRealtime = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
      };
    };
  };
}
