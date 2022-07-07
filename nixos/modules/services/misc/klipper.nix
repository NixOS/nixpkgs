{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.klipper;
  format = pkgs.formats.ini {
    # https://github.com/NixOS/nixpkgs/pull/121613#issuecomment-885241996
    listToValue = l:
      if builtins.length l == 1 then generators.mkValueStringDefault {} (head l)
      else lib.concatMapStrings (s: "\n  ${generators.mkValueStringDefault {} s}") l;
    mkKeyValue = generators.mkKeyValueDefault {} ":";
  };
in
{
  ##### interface
  options = {
    services.klipper = {
      enable = mkEnableOption "Klipper, the 3D printer firmware";

      package = mkOption {
        type = types.package;
        default = pkgs.klipper;
        defaultText = literalExpression "pkgs.klipper";
        description = "The Klipper package.";
      };

      inputTTY = mkOption {
        type = types.path;
        default = "/run/klipper/tty";
        description = "Path of the virtual printer symlink to create.";
      };

      apiSocket = mkOption {
        type = types.nullOr types.path;
        default = "/run/klipper/api";
        description = "Path of the API socket to create.";
      };

      octoprintIntegration = mkOption {
        type = types.bool;
        default = false;
        description = "Allows Octoprint to control Klipper.";
      };

      user = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          User account under which Klipper runs.

          If null is specified (default), a temporary user will be created by systemd.
        '';
      };

      group = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Group account under which Klipper runs.

          If null is specified (default), a temporary user will be created by systemd.
        '';
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
    assertions = [
      {
        assertion = cfg.octoprintIntegration -> config.services.octoprint.enable;
        message = "Option klipper.octoprintIntegration requires Octoprint to be enabled on this system. Please enable services.octoprint to use it.";
      }
      {
        assertion = cfg.user != null -> cfg.group != null;
        message = "Option klipper.group is not set when a user is specified.";
      }
    ];

    environment.etc."klipper.cfg".source = format.generate "klipper.cfg" cfg.settings;

    services.klipper = mkIf cfg.octoprintIntegration {
      user = config.services.octoprint.user;
      group = config.services.octoprint.group;
    };

    systemd.services.klipper = let
      klippyArgs = "--input-tty=${cfg.inputTTY}"
        + optionalString (cfg.apiSocket != null) " --api-server=${cfg.apiSocket}";
    in {
      description = "Klipper 3D Printer Firmware";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/lib/klipper/klippy.py ${klippyArgs} /etc/klipper.cfg";
        RuntimeDirectory = "klipper";
        SupplementaryGroups = [ "dialout" ];
        WorkingDirectory = "${cfg.package}/lib";
      } // (if cfg.user != null then {
        Group = cfg.group;
        User = cfg.user;
      } else {
        DynamicUser = true;
        User = "klipper";
      });
    };
  };
}
