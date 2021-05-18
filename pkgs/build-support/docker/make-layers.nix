{ flattenReferencesGraph, runCommand, coreutils }:
{
  baseJson,
  contentsList ? [],
  pipeline ? [],
  debug ? false
}: runCommand "docker-make-layers"
{
  __structuredAttrs = true;
  # graph, exclude_paths and pipeline are expected by the
  # flatten_references_graph executable.
  exportReferencesGraph.graph = [baseJson] ++ contentsList;
  # We don't need baseJson to be included in layers (all it's deps will be
  # included though).
  exclude_paths = [baseJson];
  inherit pipeline;
  # builder cannot refer to derivation outputs
  PATH = "${flattenReferencesGraph}/bin";
  builder = builtins.toFile "docker-make-layers-builder"
    ''
      . .attrs.sh

      ${if debug then "DEBUG=True" else ""} \
        flatten_references_graph .attrs.json > ''${outputs[out]}
    '';
  }
  ""
