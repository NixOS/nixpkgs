{ config, pkgs, lib, ... }:

with lib;

let
  pamCfg = config.security.pam;
  cfg = pamCfg.modules.otpw;

  anyEnable = any (attrByPath [ "modules" "otpw" "enable" ] false) (attrValues pamCfg.services);

  moduleOptions = global: {
    enable = mkOption {
      default = if global then false else cfg.enable;
      type = types.bool;
      description = ''
        Whether to enable the OTPW (one-time password) PAM module.
        If true, the OTPW system will be used (if <filename>~/.otpw</filename>
        exists).
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
              modules.otpw = moduleOptions false;
            };

            config = mkIf config.modules.otpw.enable {
              auth.otpw = {
                control = "sufficient";
                path = "${pkgs.otpw}/lib/security/pam_otpw.so";
                order = 31000;
              };

              session.otpw = {
                control = "optional";
                path = "${pkgs.otpw}/lib/security/pam_otpw.so";
                order = 10000;
              };
            };
          })
        );
      };

      modules.otpw = moduleOptions true;
    };
  };

  config = mkIf (cfg.enable || anyEnable) {
    environment.systemPackages = [ pkgs.otpw ];
  };
}
