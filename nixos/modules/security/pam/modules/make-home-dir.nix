{ config, pkgs, lib, ... }:

with lib;

let
  pamCfg = config.security.pam;
  cfg = pamCfg.modules.makeHomeDir;

  moduleOptions = global: {
    enable = mkOption {
      default = if global then false else cfg.enable;
      type = types.bool;
      description = ''
        Whether to try to create home directories for users
        with <literal>$HOME</literal>s pointing to nonexistent
        locations on session login.
      '';
    };

    skelDirectory = mkOption {
      type = types.str;
      default = if global then "/var/empty" else cfg.skelDirectory;
      example =  "/etc/skel";
      description = ''
        Path to skeleton directory whose contents are copied to home
        directories newly created by <literal>pam_mkhomedir</literal>.
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
              modules.makeHomeDir = moduleOptions false;
            };

            config = mkIf config.modules.makeHomeDir.enable {
              session.makeHomeDir = {
                control = "required";
                path = "${pkgs.pam}/lib/security/pam_mkhomedir.so";
                args = [
                  "silent"
                  "skel=${config.modules.makeHomeDir.skelDirectory}"
                  "umask=0022"
                ];
                order = 3000;
              };
            };
          })
        );
      };

      modules.makeHomeDir = moduleOptions true;
    };
  };
}
