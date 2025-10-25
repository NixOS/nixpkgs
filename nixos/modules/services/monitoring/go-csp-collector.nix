{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.services.go-csp-collector;
in
{
  meta.maintainers = with lib.maintainers; [ stepbrobd ];

  options.services.go-csp-collector = {
    enable = lib.mkEnableOption "go-csp-collector, a content security policy violation collector";

    package = lib.mkPackageOption pkgs "go-csp-collector" { };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType =
          with lib.types;
          attrsOf (oneOf [
            bool
            path
            str
          ]);

        options = {
          port = lib.mkOption {
            type = lib.types.port;
            description = "The port to use.";
            default = 8080;
            example = 8080;
          };
        };
      };

      description = ''
        Settings for go-csp-collector, see [the official documentation](https://github.com/jacobbednarz/go-csp-collector) for supported options.
      '';

      default = { };

      example = lib.literalExpression ''
        {
          debug = true;
          health-check-path = "/health";
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.go-csp-collector = {
      # TODO
    };
  };
}
