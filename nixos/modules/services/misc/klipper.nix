{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.klipper;
  package = pkgs.klipper;
  format = pkgs.formats.ini { mkKeyValue = generators.mkKeyValueDefault {} ":"; };
in
{
  ##### interface
  options = {
    services.klipper = {
      enable = mkEnableOption "Klipper, the 3D printer firmware";

      octoprintIntegration = mkOption {
        type = types.bool;
        default = false;
        description = "Allows Octoprint to control Klipper.";
      };

      settings = mkOption {
        type = format.type;
        default = { };
        description = ''
          Configuration for Klipper. See the <link xlink:href="https://www.klipper3d.org/Overview.html#configuration-and-tuning-guides">documentation</link>
          for supported values.
        '';
      };
    };
  };

  ##### implementation
  config = mkIf cfg.enable {
    assertions = [{
      assertion = cfg.octoprintIntegration -> config.services.octoprint.enable;
      message = "Option klipper.octoprintIntegration requires Octoprint to be enabled on this system. Please enable services.octoprint to use it.";
    }];

    environment.etc."klipper.cfg".source = format.generate "klipper.cfg" cfg.settings;

    systemd.services.klipper = {
      description = "Klipper 3D Printer Firmware";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${package}/lib/klipper/klippy.py --input-tty=/run/klipper/tty /etc/klipper.cfg";
        RuntimeDirectory = "klipper";
        SupplementaryGroups = [ "dialout" ];
        WorkingDirectory = "${package}/lib";
      } // (if cfg.octoprintIntegration then {
        Group = config.services.octoprint.group;
        User = config.services.octoprint.user;
      } else {
        DynamicUser = true;
        User = "klipper";
      });
    };
  };
}
