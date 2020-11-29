{ config, pkgs, lib, ... }:

with lib;

let
  topCfg = config;
  pamCfg = config.security.pam;
  cfg = pamCfg.modules.appArmor;

  moduleOptions = global: {
    enable = mkOption {
      default = if global then false else cfg.enable;
      type = types.bool;
      description = ''
        Enable support for attaching AppArmor profiles at the
        user/group level, e.g., as part of a role based access
        control scheme.
      '';
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
              modules.appArmor = moduleOptions false;
            };

            config = mkIf (config.modules.appArmor.enable && topCfg.security.apparmor.enable) {
              session = mkDefault {
                appArmor = {
                  control = "optional";
                  path = "${pkgs.apparmor-pam}/lib/security/pam_apparmor.so";
                  args = [
                    "order=user,group,default"
                    "debug"
                  ];
                  order = 15000;
                };
              };
            };
          })
        );
      };

      modules.appArmor = moduleOptions true;
    };
  };
}
