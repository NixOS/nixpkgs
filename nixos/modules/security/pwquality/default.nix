{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) types;
  cfg = config.security.pwquality;

  conf = import ./pwquality-conf-format.nix { inherit pkgs lib; };
in
{
  options = {
    security.pwquality = {
      package = lib.mkPackageOption pkgs "libpwquality" { };

      pam = {
        # enabled and enforced between pam.nix
        # setting adopted by definition in pamOpts for `security.pam.services.<name>.pwquality`
        enable = lib.mkEnableOption "Enable PAM pwquality system globally to enforce complex passwords.";

        # mirror from within pam
        control = lib.mkOption {
          default = "required";
          type = lib.types.enum [
            "required"
            "requisite"
            "sufficient"
            "optional"
          ];
          description = ''
            This option sets pam "control".
            If you want to have multi factor authentication, use "required".
            If you want to use U2F device instead of regular password, use "sufficient".

            Read
            {manpage}`pam.conf(5)`
            for better understanding of this option.
          '';
        };

        settings = lib.mkOption {
          description = ''
            Config options for libpwquality in PAM.

            Inherits default value from [](#opt-security.pwquality.settings) and
            where you should likely configure things. Set values here if PAM
            config globally must differ from general libpwqualtiy use.
            See {manpage}`pwquality.conf(5)` man page for available options.
          '';
          default = cfg.settings;
          defaultText = lib.literalExpression "config.security.pwquality.settings";
          type = conf.type;
        };
      };

      writeGlobalSettings = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Writes libpwquality config to {file}`/etc/security/pwquality.conf` for
          use globally.
        '';
      };

      settings = lib.mkOption {
        description = ''
          Config options for libpwquality components to reference and
          additionally write to {file}`/etc/security/pwquality.conf` file if
          [`writeGlobalSettings`](#opt-security.pwquality.settings) is used.
          See {manpage}`pwquality.conf(5)` man page for available options.
        '';
        default = { };
        example = lib.literalExpression ''
          {
            minlen = 10;
            # require each class: lowercase uppercase digit and symbol/other
            minclass = 4;
            badwords = [ "foobar" "hunter42" "password" ];
            enforce_for_root = true;
          }
        '';
        type = conf.type;
      };
    };
  };

  config = lib.mkIf cfg.writeGlobalSettings {
    # environment.systemPackages = [ pkgs.libpwquality ];
    environment.etc."security/pwquality.conf".source = pkgs.writeText "pwquality.conf" (
      conf.generate cfg.settings
    );
  };
}
