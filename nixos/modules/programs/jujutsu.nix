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
in
{
  meta.maintainers = cfg.package.meta.maintainers;

  options.programs.jujutsu = {
    enable = mkEnableOption "`jujutsu`, a powerful Git-compatible VCS";

    settings = mkOption {
      type = lib.types.submodule {
        freeformType = format.type;

        options = {
          ui.default-command = mkOption {
            type = lib.types.nullOr (lib.types.either lib.types.str (lib.types.listOf lib.types.str));
            example = "[\"log\", \"--reversed\"]";
            description = "The default subcommand to run";
          };

          revset-aliases."immutable_heads()" = mkOption {
            type = lib.types.nullOr lib.types.str;
            example = "builtin_immutable_heads() | ~mine()";
            description = "The set of commits to consider immutable";
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
    environment.systemPackages = [ cfg.package ];

    environment.etc."jj/config.toml" = mkIf (cfg.settings != { }) {
      source = format.generate "jujutsu-config.toml" cfg.settings;
    };

    assertions = [
      {
        assertion = versionAtLeast "0.43.0" cfg.package.version;
        message = "jujutsu support for system-wide configuration was added in 0.43.0";
      }
    ];
  };
}
