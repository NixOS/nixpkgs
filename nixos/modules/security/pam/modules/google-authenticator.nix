{ config, pkgs, lib, ... }:

with lib;

let
  pamCfg = config.security.pam;
  cfg = pamCfg.modules.googleAuthenticator;

  moduleOptions = global: {
    enable = mkOption {
      default = if global then false else cfg.enable;
      type = types.bool;
      description = ''
        If set, users with enabled Google Authenticator (created
        <filename>~/.google_authenticator</filename>) will be required
        to provide Google Authenticator token to log in.
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
              modules.googleAuthenticator = moduleOptions false;
            };

            config = mkIf config.modules.googleAuthenticator.enable {
              auth.googleAuthenticator = {
                control = "required";
                path = "${pkgs.googleAuthenticator}/lib/security/pam_google_authenticator.so";
                args = [ "no_increment_hotp" ];
                order = 27000;
              };
            };
          })
        );
      };

      modules.googleAuthenticator = moduleOptions true;
    };
  };
}
