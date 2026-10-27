{
  callPackage,
  fetchurl,
  lib,
  ramalama,
}:

let
  modelData = builtins.fromJSON (builtins.readFile ./mlx-model-files.json);

  modelFiles = map (file: {
    inherit (file) name;
    src = fetchurl {
      url = "https://huggingface.co/${modelData.repo}/resolve/${modelData.revision}/${file.name}";
      inherit (file) hash;
    };
  }) modelData.files;

  refFile = builtins.toJSON {
    version = "v1.0.1";
    hash = modelData.revision;
    path = "";
    files = map (file: {
      hash = file.name;
      inherit (file) name;
      type = if lib.hasSuffix ".safetensors" file.name then "safetensor" else "other";
    }) modelData.files;
  };
in
(callPackage ./common.nix { inherit ramalama; }).mkServeTest {
  name = "ramalama-mlx-test";
  runtime = "mlx";
  port = 18081;
  model = "hf://${modelData.repo}";

  setup = ''
    modelBase="$TMPDIR/store/store/huggingface/${modelData.repo}"
    snapshot="$modelBase/snapshots/${modelData.revision}"
    mkdir -p "$modelBase/blobs" "$modelBase/refs" "$snapshot"

    ${lib.concatMapStrings (file: ''
      ln -s ${file.src} "$modelBase/blobs/${file.name}"
      ln -s "$modelBase/blobs/${file.name}" "$snapshot/${file.name}"
    '') modelFiles}

    cat >"$modelBase/refs/latest.json" <<'EOF'
    ${refFile}
    EOF
  '';
}
