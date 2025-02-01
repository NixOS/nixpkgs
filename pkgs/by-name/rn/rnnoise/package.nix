{
  stdenv,
  lib,
  fetchurl,
  fetchzip,
  autoreconfHook,
  writeScript,
  fetchpatch,
  modelUrl ? "",
  modelHash ? "", # Allow overriding the model URL and hash
}:

let
  modelVersionJSON = lib.importJSON ./model-version.json;

  # Copy from https://gitlab.xiph.org/xiph/rnnoise/-/raw/v${version}/model_version
  default_model_version = modelVersionJSON.version;

  # Either use the default model or the one provided by package override
  model_url =
    if (modelUrl == "") then
      "https://media.xiph.org/rnnoise/models/rnnoise_data-${default_model_version}.tar.gz"
    else
      modelUrl;
  model_hash = if (modelHash == "") then modelVersionJSON.hash else modelHash;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "rnnoise";
  version = "0.2";

  src = fetchzip {
    urls = [
      "https://gitlab.xiph.org/xiph/rnnoise/-/archive/v${finalAttrs.version}/rnnoise-v${finalAttrs.version}.tar.gz"
      "https://github.com/xiph/rnnoise/archive/v${finalAttrs.version}.tar.gz"
    ];
    hash = "sha256-Qaf+0iOprq7ILRWNRkBjsniByctRa/lFVqiU5ZInF/Q=";
  };

  patches = [
    # remove when updating
    (fetchpatch {
      url = "https://github.com/xiph/rnnoise/commit/372f7b4b76cde4ca1ec4605353dd17898a99de38.patch";
      hash = "sha256-Dzikb59hjVxd1XIEj/Je4evxtGORkaNcqE+zxOJMSvs=";
    })
  ];

  model = fetchurl {
    url = model_url;
    hash = model_hash;
  };

  postPatch = ''
    tar xvomf ${finalAttrs.model}
  '';

  nativeBuildInputs = [ autoreconfHook ];

  postInstall = ''
    install -Dt $out/bin examples/.libs/rnnoise_demo
  '';

  passthru.updateScript = writeScript "update-rnnoise.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts nix nix-prefetch findutils moreutils

    prefetch-sri() {
        nix-prefetch-url "$1" | xargs nix hash to-sri --type sha256
    }

    res="$(curl ''${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
      -sL "https://api.github.com/repos/xiph/rnnoise/tags?per_page=1")"

    version="$(echo $res | jq '.[0].name | split("v") | .[1]' --raw-output)"
    update-source-version ${finalAttrs.pname} "$version" --ignore-same-hash

    model_version=$(curl -sL "https://raw.githubusercontent.com/xiph/rnnoise/v$version/model_version")
    model_url="https://media.xiph.org/rnnoise/models/rnnoise_data-$model_version.tar.gz"
    model_hash="$(prefetch-sri $model_url)"

    modelJson=pkgs/development/libraries/rnnoise/model-version.json

    jq --arg version "$model_version" \
        --arg hash "$model_hash" \
        '.version = $version | .hash = $hash' \
        "$modelJson" | sponge "$modelJson"
  '';

  meta = {
    description = "Recurrent neural network for audio noise reduction";
    homepage = "https://people.xiph.org/~jm/demo/rnnoise/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nh2 ];
    mainProgram = "rnnoise_demo";
    platforms = lib.platforms.all;
  };
})
