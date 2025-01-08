{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.buildkite-agent;
in
{
  port = 9876;
  extraOpts = {
    tokenPath = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      apply = final: if final == null then null else toString final;
      description = ''
        The token from your Buildkite "Agents" page.

        A run-time path to the token file, which is supposed to be provisioned
        outside of Nix store.
      '';
    };
    interval = lib.mkOption {
      type = lib.types.str;
      default = "30s";
      example = "1min";
      description = ''
        How often to update metrics.
      '';
    };
    endpoint = lib.mkOption {
      type = lib.types.str;
      default = "https://agent.buildkite.com/v3";
      description = ''
        The Buildkite Agent API endpoint.
      '';
    };
    queues = lib.mkOption {
      type = with lib.types; nullOr (listOf str);
      default = null;
      example = lib.literalExpression ''[ "my-queue1" "my-queue2" ]'';
      description = ''
        Which specific queues to process.
      '';
    };
  };
  serviceOpts = {
    script =
      let
        queues = lib.concatStringsSep " " (map (q: "-queue ${q}") cfg.queues);
      in
      ''
        export BUILDKITE_AGENT_TOKEN="$(cat ${toString cfg.tokenPath})"
        exec ${pkgs.buildkite-agent-metrics}/bin/buildkite-agent-metrics \
          -backend prometheus \
          -interval ${cfg.interval} \
          -endpoint ${cfg.endpoint} \
          ${lib.optionalString (cfg.queues != null) queues} \
          -prometheus-addr "${cfg.listenAddress}:${toString cfg.port}" ${lib.concatStringsSep " " cfg.extraFlags}
      '';
    serviceConfig = {
      DynamicUser = false;
      RuntimeDirectory = "buildkite-agent-metrics";
    };
  };
}
