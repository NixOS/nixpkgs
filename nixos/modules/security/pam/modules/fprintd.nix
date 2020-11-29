{ config, pkgs, lib, ... }:

with lib;

# TODO: move this to its module

let
  pamCfg = config.security.pam;
  cfg = pamCfg.modules.fprintd;

  moduleOptions = global: {
    enable = mkOption {
      default = if global then config.services.fprintd.enable else cfg.enable;
      type = types.bool;
      description = ''
        If true, fingerprint reader will be used (if exists and
        your fingerprints are enrolled).
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
              modules.fprintd = moduleOptions false;
            };

            config = mkIf config.modules.fprintd.enable {
              auth = {
                fprintd = {
                  control = "sufficient";
                  path = "${pkgs.fprintd}/lib/security/pam_fprintd.so";
                  order = 15000;
                };
              };
            };
          })
        );
      };

      modules.fprintd = moduleOptions true;
    };
  };
}
