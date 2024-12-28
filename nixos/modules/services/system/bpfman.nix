{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.bpfman;
  settingsFormat = pkgs.formats.toml { };

  inherit (lib)
    literalExpression
    mkIf
    mkOption
    mkEnableOption
    mkPackageOption
    ;

  inherit (lib.types) submodule;
in
{
  options.services.bpfman = {
    enable = mkEnableOption "bpfman";
    package = mkPackageOption pkgs "bpfman" { };

    settings = mkOption {
      type = submodule {
        freeformType = settingsFormat.type;
      };

      default = { };

      example = literalExpression ''
        {
          signing.allow_unsigned = true;
          database.max_retries = 10;
        }
      '';

      description = ''
        Configuration for bpfman.
        Supported options can be found at the [docs](https://bpfman.io/v0.5.4/developer-guide/configuration).
      '';
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [ pkgs.bpfman ];
      etc."bpfman/bpfman.toml".source = settingsFormat.generate "bpfman.toml" cfg.settings;
    };

    systemd.packages = [ pkgs.bpfman ];
  };
}
