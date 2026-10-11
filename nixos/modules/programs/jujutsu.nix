{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.programs.jujutsu;
  format = pkgs.formats.toml { };

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    versionAtLeast
    ;

  inherit (lib.types)
    submodule
    nullOr
    either
    str
    listOf
    ;

in
{
  meta.maintainers = pkgs.jujutsu.meta.maintainers;

  options.programs.jujutsu = {
    enable = mkEnableOption "`jujutsu`, a powerful Git-compatible VCS";

    settings = mkOption {
      type = submodule {
        freeformType = format.type;

        options = {
          ui.default-command = mkOption {
            type = nullOr (either str (listOf str));
            example = [
              "log"
              "--reversed"
            ];
            description = "The default subcommand to run";
            default = null;
          };

          revset-aliases."immutable_heads()" = mkOption {
            type = nullOr str;
            example = "builtin_immutable_heads() | ~mine()";
            description = "The set of commits to consider immutable";
            default = null;
          };
        };
      };

      default = { };
      description = ''
        Generates the system-wide config.toml file. Refer to
        <https://docs.jj-vcs.dev/latest/config> for details
        on supported values.
      '';
    };

    package = mkPackageOption pkgs "jujutsu" { };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = versionAtLeast "0.43.0" cfg.package.version;
        message = "jujutsu is too old. The version supplied is ${cfg.package.version}, and support for system-wide configuration was added in 0.43.0";
      }
    ];

    environment = {
      systemPackages = [ cfg.package ];

      etc."jj/config.toml".source = format.generate "jujutsu-config.toml" cfg.settings;
    };
  };
}
