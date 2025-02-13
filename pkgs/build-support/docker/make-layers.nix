{
  coreutils,
  flattenReferencesGraph,
  lib,
  jq,
  runCommand,
}:
{
  closureRoots,
  excludePaths ? [ ],
  # This could be a path to (or a derivation producing a path to)
  # a json file containing the pipeline
  pipeline ? [ ],
  debug ? false,
}:
if closureRoots == [ ] then
  builtins.toFile "docker-layers-empty" "[]"
else
  runCommand "docker-layers"
    {
      __structuredAttrs = true;
      # graph, exclude_paths and pipeline are expected by the
      # flatten_references_graph executable.
      exportReferencesGraph.graph = closureRoots;
      exclude_paths = excludePaths;
      inherit pipeline;
      nativeBuildInputs = [
        coreutils
        flattenReferencesGraph
        jq
      ];
    }
    ''
      . .attrs.sh

      flatten_references_graph_arg=.attrs.json

      echo "pipeline: $pipeline"

      if jq -e '.pipeline | type == "string"' .attrs.json; then
        jq '. + { "pipeline": $pipeline[0] }' \
          --slurpfile pipeline "$pipeline" \
          .attrs.json > flatten_references_graph_arg.json

        flatten_references_graph_arg=flatten_references_graph_arg.json
      fi

      ${lib.optionalString debug "export DEBUG=True"}
      flatten_references_graph "$flatten_references_graph_arg" > ''${outputs[out]}
    ''
