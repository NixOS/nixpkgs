{ runCommand, jq }: image: runCommand "image-layers-count" {
  inherit image;
  nativeBuildInputs = [ jq ];
} ''
  tar -xOf "$image" manifest.json | jq '.[0].Layers | length' > $out
''
