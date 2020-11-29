{ config, pkgs, lib, ... }:

with lib;

let
  topCfg = config;
  pamCfg = config.security.pam;
  cfg = pamCfg.modules.motd;

  moduleOptions = global: {
    enable = mkOption {
      default = if global then false else cfg.enable;
      type = types.bool;
      description = "Whether to show the message of the day.";
    };

    motdFile = mkOption {
      type = types.path;
      default = pkgs.writeText "motd" config.users.motd;
      description = "The path to the motd file.";
    };
  };
in
{
  options = {
    security.pam = {
      services = mkOption {
        type = with types; attrsOf (submodule
          ({ config, ... }: {
            options = {
              modules.motd = moduleOptions false;
            };

            config = mkIf (config.modules.motd.enable && topCfg.users.motd != null) {
              session.motd = {
                control = "optional";
                path = "${pkgs.pam}/lib/security/pam_motd.so";
                args = [ "motd=${config.motdFile}" ];
                order = 14000;
              };
            };
          })
        );
      };

      modules.motd = moduleOptions true;
    };

    users.motd = mkOption {
      default = null;
      type = types.nullOr types.lines;
      description = "Message of the day shown to users when they log in.";
      example = "Today is Sweetmorn, the 4th day of The Aftermath in the YOLD 3178.";
    };
  };
}
