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
    environment.etc."security/pwquality.conf".source = conf.generate "pwquality.conf" cfg.settings;
  };
}
