{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.rspamd;

  prettyJSON = conf:
    pkgs.runCommand "rspamd-exporter-config.yml" { } ''
      echo '${builtins.toJSON conf}' | ${pkgs.buildPackages.jq}/bin/jq '.' > $out
    '';

  generateConfig = extraLabels: {
    metrics = (map (path: {
      name = "rspamd_${replaceStrings [ "." " " ] [ "_" "_" ] path}";
      path = "$.${path}";
      labels = extraLabels;
    }) [
      "actions.'add header'"
      "actions.'no action'"
      "actions.'rewrite subject'"
      "actions.'soft reject'"
      "actions.greylist"
      "actions.reject"
      "bytes_allocated"
      "chunks_allocated"
      "chunks_freed"
      "chunks_oversized"
      "connections"
      "control_connections"
      "ham_count"
      "learned"
      "pools_allocated"
      "pools_freed"
      "read_only"
      "scanned"
      "shared_chunks_allocated"
      "spam_count"
      "total_learns"
    ]) ++ [{
      name = "rspamd_statfiles";
      type = "object";
      path = "$.statfiles[*]";
      labels = recursiveUpdate {
        symbol = "$.symbol";
        type = "$.type";
      } extraLabels;
      values = {
        revision = "$.revision";
        size = "$.size";
        total = "$.total";
        used = "$.used";
        languages = "$.languages";
        users = "$.users";
      };
    }];
  };
in
{
  port = 7980;
  extraOpts = {
    extraLabels = mkOption {
      type = types.attrsOf types.str;
      default = {
        host = config.networking.hostName;
      };
      defaultText = "{ host = config.networking.hostName; }";
      example = literalExample ''
        {
          host = config.networking.hostName;
          custom_label = "some_value";
        }
      '';
      description = "Set of labels added to each metric.";
    };
  };
  serviceOpts.serviceConfig.ExecStart = ''
    ${pkgs.prometheus-json-exporter}/bin/json_exporter \
      --config.file ${prettyJSON (generateConfig cfg.extraLabels)} \
      --web.listen-address "${cfg.listenAddress}:${toString cfg.port}" \
      ${concatStringsSep " \\\n  " cfg.extraFlags}
  '';

  imports = [
    (mkRemovedOptionModule [ "url" ] ''
      This option was removed. The URL of the rspamd metrics endpoint
      must now be provided to the exporter by prometheus via the url
      parameter `target'.

      In prometheus a scrape URL would look like this:

        http://some.rspamd-exporter.host:7980/probe?target=http://some.rspamd.host:11334/stat

      For more information, take a look at the official documentation
      (https://github.com/prometheus-community/json_exporter) of the json_exporter.
    '')
     ({ options.warnings = options.warnings; options.assertions = options.assertions; })
  ];
}
