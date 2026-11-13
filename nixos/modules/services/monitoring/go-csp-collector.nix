{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.go-csp-collector;

  inherit (lib)
    boolToString
    concatStringsSep
    getExe
    isBool
    literalExpression
    maintainers
    mapAttrsToList
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;

  settingsToArgs =
    settings:
    concatStringsSep " " (
      mapAttrsToList (
        name: value:
        let
          flag = "-${name}";
        in
        if isBool value then "${flag}=${boolToString value}" else "${flag} ${toString value}"
      ) settings
    );
in
{
  meta.maintainers = with maintainers; [ stepbrobd ];

  options.services.go-csp-collector = {
    enable = mkEnableOption "go-csp-collector, a content security policy violation collector";

    package = mkPackageOption pkgs "go-csp-collector" { };

    settings = mkOption {
      type = types.submodule {
        freeformType =
          with types;
          attrsOf (oneOf [
            bool
            path
            str
          ]);

        options = {
          port = mkOption {
            type = types.port;
            description = "The port to listen on.";
            default = 8080;
            example = 8080;
          };

          output-format = mkOption {
            type = types.enum [
              "text"
              "json"
            ];
            description = "Define how the violation reports are formatted for output.";
            default = "text";
            example = "text";
          };
        };
      };

      description = ''
        Settings for go-csp-collector. See
        <https://github.com/jacobbednarz/go-csp-collector> for supported options.
      '';

      default = { };

      example = literalExpression ''
        {
          debug = true;
          health-check-path = "/health";
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.packages = [ cfg.package ];
    systemd.services.go-csp-collector = {
      description = "CSP violation collector";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ReadOnlyPaths = cfg.settings.filter-file or "";
        ExecStart = [
          ""
          "${getExe cfg.package} ${settingsToArgs cfg.settings}"
        ];
      };
    };
  };
}
