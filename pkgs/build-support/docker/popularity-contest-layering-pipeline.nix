{
  lib,
  runCommand,
  jq,
}:
{
  maxLayers,
  fromImage ? null,
}:
runCommand "popularity-contest-layering-pipeline.json" { inherit maxLayers; } ''
  # Compute the number of layers that are already used by a potential
  # 'fromImage' as well as the customization layer. Ensure that there is
  # still at least one layer available to store the image contents.
  # one layer will be taken up by the customisation layer
  usedLayers=1

  ${lib.optionalString (fromImage != null) ''
    # subtract number of base image layers
    baseImageLayersCount=$(tar -xOf "${fromImage}" manifest.json | ${lib.getExe jq} '.[0].Layers | length')

    (( usedLayers += baseImageLayersCount ))
  ''}

  if ! (( $usedLayers < $maxLayers )); then
    echo >&2 "Error: usedLayers $usedLayers layers to store 'fromImage' and" \
              "'extraCommands', but only maxLayers=$maxLayers were" \
              "allowed. At least 1 layer is required to store contents."
    exit 1
  fi
  availableLayers=$(( maxLayers - usedLayers ))

  # Produce pipeline which uses popularity_contest algo.
  echo '[["popularity_contest"],["limit_layers",'$availableLayers']]' > $out
''
