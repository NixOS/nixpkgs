{ config, pkgs, lib, ... }:

with lib;

let
  pamCfg = config.security.pam;
  cfg = pamCfg.modules.oath;

  anyEnable = any (attrByPath [ "modules" "oath" "enable" ] false) (attrValues pamCfg.services);

  moduleOptions = global: {
    enable = mkOption {
      type = types.bool;
      default = if global then false else cfg.enable;
      description = ''
        Enable the OATH (one-time password) PAM module.
      '';
    };

    digits = mkOption {
      type = types.enum [ 6 7 8 ];
      default = if global then 6 else cfg.digits;
      description = ''
        Specify the length of the one-time password in number of
        digits.
      '';
    };

    window = mkOption {
      type = types.int;
      default = if global then 5 else cfg.window;
      description = ''
        Specify the number of one-time passwords to check in order
        to accommodate for situations where the system and the
        client are slightly out of sync (iteration for HOTP or time
        steps for TOTP).
      '';
    };

    usersFile = mkOption {
      type = types.path;
      default = if global then "/etc/users.oath" else cfg.usersFile;
      description = ''
        Set the path to file where the user's credentials are
        stored. This file must not be world readable!
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
              modules.oath = moduleOptions false;
            };

            config = mkIf config.modules.oath.enable {
              auth.oath = {
                control = "requisite";
                path = "${pkgs.oathToolkit}/lib/security/pam_oath.so";
                args = [
                  "window=${toString config.modules.oath.window}"
                  "usersfile=${toString config.modules.oath.usersFile}"
                  "digits=${toString config.modules.oath.digits}"
                ];
                order = 19000;
              };
            };
          })
        );
      };

      modules.oath = moduleOptions true;
    };
  };

  config = mkIf (cfg.enable || anyEnable) {
    environment.systemPackages = [ pkgs.oathToolkit ];
  };
}
