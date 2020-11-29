{ config, pkgs, lib, ... }:

with lib;

let
  pamCfg = config.security.pam;
  cfg = pamCfg.modules.duoSecurity;

  moduleOptions = global: {
    enable = mkOption {
      default = if global then false else cfg.enable;
      type = types.bool;
      description = ''
        If set, use the Duo Security pam module
        <literal>pam_duo</literal> for authentication.  Requires
        configuration of <option>security.duosec</option> options.
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
              modules.duoSecurity = moduleOptions false;
            };

            config = mkIf config.modules.duoSecurity.enable {
              auth = mkDefault {
                duoSecurity = {
                  control = "required";
                  path = "${pkgs.duo-unix}/lib/security/pam_duo.so";
                  order = 28000;
                };
              };
            };
          })
        );
      };

      modules.duoSecurity = moduleOptions true;
    };
  };
}
