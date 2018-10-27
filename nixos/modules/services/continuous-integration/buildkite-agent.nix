{ config, lib, pkgs, options, ... }:

with lib;

let
  cfg = config.services.buildkite-agent;
in

{
  options = {
    services.buildkite-agent = mkOption {
      description = ''
        Moved to services.buildkite-agents.
      '';
      default = { };
    };
  };

  config = mkIf (cfg.enable or false) {
    services.buildkite-agents."" = (lib.mkAliasDefinitions (options.services.buildkite-agent));
    warnings = [ "services.buildkite-agent has been moved to an attribute set at services.buildkite-agents" ];
  };
}
