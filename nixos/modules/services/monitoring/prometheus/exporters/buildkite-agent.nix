{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.buildkite-agent;
  inherit (lib)
    mkOption
    types
    concatStringsSep
    optionalString
    literalExpression
    ;
in
{
  port = 9876;
  extraOpts = {
    tokenPath = mkOption {
      type = types.nullOr types.path;
      apply = final: if final == null then null else toString final;
      description = ''
        The token from your Buildkite "Agents" page.

        A run-time path to the token file, which is supposed to be provisioned
        outside of Nix store.
      '';
    };
    interval = mkOption {
      type = types.str;
      default = "30s";
      example = "1min";
      description = ''
        How often to update metrics.
      '';
    };
    endpoint = mkOption {
      type = types.str;
      default = "https://agent.buildkite.com/v3";
      description = ''
        The Buildkite Agent API endpoint.
      '';
    };
    queues = mkOption {
      type = with types; nullOr (listOf str);
      default = null;
      example = literalExpression ''[ "my-queue1" "my-queue2" ]'';
      description = ''
        Which specific queues to process.
      '';
    };
  };
  serviceOpts = {
    script =
      let
        queues = concatStringsSep " " (map (q: "-queue ${q}") cfg.queues);
      in
      ''
        export BUILDKITE_AGENT_TOKEN="$(cat ${toString cfg.tokenPath})"
        exec ${pkgs.buildkite-agent-metrics}/bin/buildkite-agent-metrics \
          -backend prometheus \
          -interval ${cfg.interval} \
          -endpoint ${cfg.endpoint} \
          ${optionalString (cfg.queues != null) queues} \
          -prometheus-addr "${cfg.listenAddress}:${toString cfg.port}" ${concatStringsSep " " cfg.extraFlags}
      '';
    serviceConfig = {
      DynamicUser = false;
      RuntimeDirectory = "buildkite-agent-metrics";
    };
  };
}
