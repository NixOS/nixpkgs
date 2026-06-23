{
  callPackage,
  fetchurl,
  lib,
  ramalama,
}:

let
  common = callPackage ./common.nix {
    inherit ramalama;
  };

  modelData = builtins.fromJSON (builtins.readFile ./mlx-model-files.json);

  fetchModelFile =
    file:
    fetchurl {
      url = "https://huggingface.co/${modelData.repo}/resolve/${modelData.revision}/${file.name}";
      inherit (file) hash;
      meta.license = lib.licenses.${modelData.license};
    };

  modelFilesWithSrc = map (
    file:
    file
    // {
      src = fetchModelFile file;
    }
  ) modelData.files;

  refFile = builtins.toJSON {
    version = "v1.0.1";
    hash = modelData.revision;
    path = "";
    files = map (file: {
      hash = file.name;
      inherit (file) name type;
    }) modelData.files;
  };
in
common.mkServeTest {
  name = "ramalama-mlx-test";
  runtime = "mlx";
  port = 18081;
  model = "hf://${modelData.repo}";

  # The MLX server treats a chat request's model field as a model to resolve,
  # so ramalama intentionally omits it for this runtime.
  includeModelInChat = false;

  meta.platforms = [ "aarch64-darwin" ];
  serveArgs = [
    "--max-tokens"
    "16"
    "--pull"
    "never"
    "--temp"
    "0"
  ];

  setup = ''
    modelBase="$TMPDIR/store/store/huggingface/${modelData.repo}"
    snapshot="$modelBase/snapshots/${modelData.revision}"
    mkdir -p "$modelBase/blobs" "$modelBase/refs" "$snapshot"

    ${lib.concatMapStrings (file: ''
      ln -s ${file.src} "$modelBase/blobs/${file.name}"
      ln -s "$modelBase/blobs/${file.name}" "$snapshot/${file.name}"
    '') modelFilesWithSrc}

    cat >"$modelBase/refs/latest.json" <<'EOF'
    ${refFile}
    EOF

    ramalama \
      --runtime mlx \
      --store "$TMPDIR/store" \
      pull \
      ${lib.escapeShellArg "hf://${modelData.repo}"}
  '';
}
