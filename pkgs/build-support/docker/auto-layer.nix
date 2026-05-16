{
  jq,
  lib,
  python3,
  runCommand,
  writeText,
}:

{
  closureRoots,
  excludePaths ? [ ],
  maxLayers ? 100,
  fromImage ? null,
  debug ? false,
}:

runCommand "layers.json"
  {
    __structuredAttrs = true;
    exportReferencesGraph.graph = closureRoots;
    inherit fromImage maxLayers;
    nativeBuildInputs = [
      jq
      python3
    ];
    excludePathsFile = writeText "excludePaths" (lib.concatMapStrings (x: x + "\n") excludePaths);
  }
  ''
    # Compute the number of layers that are already used by a potential
    # 'fromImage' as well as the customization layer. Ensure that there is
    # still at least one layer available to store the image contents.
    # one layer will be taken up by the customisation layer
    usedLayers=1

    if [ -n "$fromImage" ]; then
      # subtract number of base image layers
      baseImageLayersCount=$(tar -xOf "$fromImage" manifest.json | jq '.[0].Layers | length')
      (( usedLayers += baseImageLayersCount ))
    fi

    if ! (( $usedLayers < $maxLayers )); then
      echo >&2 "Error: usedLayers $usedLayers layers to store 'fromImage' and" \
                "'extraCommands', but only maxLayers=$maxLayers were" \
                "allowed. At least 1 layer is required to store contents."
      exit 1
    fi
    availableLayers=$(( maxLayers - usedLayers ))

    jq .graph "$NIX_ATTRS_JSON_FILE" > referencesGraph
    ${lib.optionalString debug "export DEBUG=1"}
    python3 ${./auto-layer.py} referencesGraph $excludePathsFile $availableLayers > $out
  ''
