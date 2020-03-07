{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.rspamd;

  prettyJSON = conf:
    pkgs.runCommand "rspamd-exporter-config.yml" { } ''
      echo '${builtins.toJSON conf}' | ${pkgs.buildPackages.jq}/bin/jq '.' > $out
    '';

  generateConfig = extraLabels: (map (path: {
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
in
{
  port = 7980;
  extraOpts = {
    listenAddress = {}; # not used

    url = mkOption {
      type = types.str;
      description = ''
        URL to the rspamd metrics endpoint.
        Defaults to http://localhost:11334/stat when
        <option>services.rspamd.enable</option> is true.
      '';
    };

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
    ${pkgs.prometheus-json-exporter}/bin/prometheus-json-exporter \
      --port ${toString cfg.port} \
      ${cfg.url} ${prettyJSON (generateConfig cfg.extraLabels)} \
      ${concatStringsSep " \\\n  " cfg.extraFlags}
  '';
}
