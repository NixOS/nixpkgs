{
  lib,
  vscode-utils,
  vscode-extension-update-script,
  autoPatchelfHook,
  stdenv,
  alsa-lib,
  libuuid,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef =
    let
      sources = {
        "x86_64-linux" = {
          arch = "linux-x64";
          hash = "sha256-dZwOBehoYEqaYskvcPB55IKnG1CMToioyUJXlndqorA=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-b6LobvVngC0TFuWTC9JBQrECkoX7ewLNCpCROkXHk20=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-/EaOfoubfq1ufwB7TTQ2hqmh1ZJiZ1+B6QeYu3MoFPI=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-JhZWNlGXljsjmT3/xDi9Z7I4a2vsi/9EkWYbnlteE98=";
        };
      };
    in
    {
      name = "vscode-speech";
      publisher = "ms-vscode";
      version = "0.16.0";
    }
    // sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
    alsa-lib
    libuuid
  ];

  # Prevent fixup phase from shrinking RPATHs - we need the Release directory
  # in the RPATH for dlopen to find libMicrosoft.CognitiveServices.Speech.extension.audio.sys.so
  dontPatchELF = true;

  # libMicrosoft.CognitiveServices.Speech.core.so uses dlopen to load audio.sys.so at runtime.
  # autoPatchelfHook patches direct dependencies but can't detect dlopen calls,
  # so we add the Release directory to RPATH.
  appendRunpaths = lib.optionals stdenv.hostPlatform.isLinux [
    "${placeholder "out"}/share/vscode/extensions/ms-vscode.vscode-speech/node_modules/@vscode/node-speech/build/Release"
  ];

  passthru.updateScript = vscode-extension-update-script { };

  meta = {
    description = "Enables speech-to-text and text-to-speech capabilities in VS Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-vscode.vscode-speech";
    homepage = "https://github.com/microsoft/vscode";
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [ pathob ];
  };
}
