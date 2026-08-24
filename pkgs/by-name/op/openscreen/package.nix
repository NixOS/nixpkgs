{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  copyDesktopItems,
  makeWrapper,
  makeDesktopItem,
  xcbuild,
  electron_41,
  nodejs_22,
  nix-update-script,
  fetchgit,
}:
let
  electron = electron_41;
  nodejs = nodejs_22;

  # download model
  xenovaWhisperTiny = fetchgit {
    url = "https://huggingface.co/Xenova/whisper-tiny";
    fetchLFS = true;
    hash = "sha256-6v4CMUeFFLrN80gb7OxVv8EHIWg61Xx2khRjzhHvAnQ=";
  };

in
buildNpmPackage (finalAttrs: {
  inherit nodejs;

  pname = "openscreen";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "siddharthvaddem";
    repo = "openscreen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-csGCSYfqhQaswn/qdFeX3wZsAYlwU7V30n90HJrKslY=";
  };

  npmDepsHash = "sha256-lx38H0qG5IrjQRekLG2N+x90Zq/emPfbxOo/qDSn7iE=";

  npmRebuildFlags = [ "--ignore-scripts" ]; # Prevent running `node-gyp build`

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    xcbuild
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  configurePhase = ''
    runHook preConfigure

    # Copy manually model files
    mkdir -p caption-assets/models/Xenova/whisper-tiny
    for el in config.json generation_config.json preprocessor_config.json tokenizer.json tokenizer_config.json \
      added_tokens.json special_tokens_map.json normalizer.json merges.txt vocab.json quantize_config.json \
      onnx/encoder_model_quantized.onnx onnx/decoder_model_merged_quantized.onnx; do

        install -Dm644 "${xenovaWhisperTiny}/$el" "caption-assets/models/Xenova/whisper-tiny/$el"
    done

    # Disable download in script
    substituteInPlace scripts/fetch-caption-model.mjs \
      --replace-fail 'await download(`''${HF_BASE}/''${rel}`, path.join(modelDir, rel));' '/* skip */'

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    npm exec tsc
    npm exec vite build

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      # electronDist needs to be modifiable on Darwin
      cp -r ${electron.dist} electron-dist
      chmod -R u+w electron-dist


      # Disable code signing during build on macOS.
      # https://www.electron.build/code-signing-mac.html#how-to-disable-code-signing-during-the-build-process-on-macos
      npm exec electron-builder -- \
        --dir \
        -c.electronDist=electron-dist \
        -c.electronVersion=${electron.version} \
        -c.mac.identity=null
    ''}
    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      npm exec electron-builder -- \
        --dir \
        -c.electronDist=${electron.dist} \
        -c.electronVersion=${electron.version} \
        -c.npmRebuild=false
    ''}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p $out/share/openscreen
      cp -r release/*/*-unpacked/{locales,resources{,.pak}} $out/share/openscreen

      makeWrapper ${lib.getExe electron} $out/bin/openscreen \
          --add-flags $out/share/openscreen/resources/app.asar \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
          --set-default ELECTRON_IS_DEV 0 \
          --inherit-argv0

      install -Dm644 icons/icons/png/512x512.png $out/share/icons/hicolor/512x512/apps/openscreen.png
    ''}

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications
      cp -R release/*/mac*/Openscreen.app $out/Applications/
      makeWrapper $out/Applications/Openscreen.app/Contents/MacOS/Openscreen $out/bin/openscreen
    ''}

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "openscreen";
      desktopName = "OpenScreen";
      comment = finalAttrs.meta.description;
      icon = "openscreen";
      exec = "openscreen %u";
      categories = [
        "AudioVideo"
        "Video"
        "Utility"
      ];
      terminal = false;
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Free, open-source alternative to Screen Studio (sort of)";
    homepage = "https://openscreen.vercel.app";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Renna42
    ];
    mainProgram = "openscreen";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
