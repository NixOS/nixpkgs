# This corresponds to the arguments of createManagedProcess in svanderburg's proposal
{ lib, config, options, ... }:
let
  inherit (lib) literalExpression mkOption types;
  pathOrStr = types.coercedTo types.path (x: "${x}") types.str;
in
{
  options = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to enable the service. A service is enabled by default, because you took the effort to define its attribute.
      '';
    };
    process = mkOption {
      type = pathOrStr;
      description = ''
        When this property is specified, it translates both to: {option}`foreground.process` and {option}`daemon.process`.
      '';
    };
    foreground = {
      process = lib.mkOption {
        type  = pathOrStr;
        description = ''
          Path to an executable that launches a process in foreground mode.
        '';
        default = config.process;
        defaultText = literalExpression "config.process";
      };
      args = lib.mkOption {
        type = types.listOf pathOrStr;
        description = ''
          Arguments to pass to the {option}`foreground.process`.
        '';
        default = config.args;
        defaultText = literalExpression "config.args";
      };
    };
    daemon = {
      process = lib.mkOption {
        type = pathOrStr;
        description = ''
          Path to an executable that launches a process in daemon mode.
        '';
        default = config.process;
        defaultText = literalExpression "config.process";
      };
      args = lib.mkOption {
        type = types.listOf pathOrStr;
        description = ''
          Arguments to pass to the {option}`daemon.process`.
        '';
        default = config.args;
        defaultText = literalExpression "config.args";
      };
    };
    args = lib.mkOption {
      type = types.listOf pathOrStr;
      description = ''
        Arguments to pass to the `foreground.process` or `daemon.process`. In other words, these arguments are passed regardless of process manager choice.
      '';
      default = [];
    };
    # TODO more from svanderburg's proposal. Look for the list of properties after defining `createManagedProcess`
  };
}