{
  lib,
  stdenv,
  autoPatchelfHook,
  cacert,
  fetchurl,
  glib,
  libsecret,
  libpulseaudio,
  onnxruntime,
  onnxruntime-genai,
  makeBinaryWrapper,
  bash,
  nodejs,
  versionCheckHook,
}:
let
  arch =
    if stdenv.hostPlatform.isx86_64 then
      "x64"
    else if stdenv.hostPlatform.isAarch64 then
      "arm64"
    else
      throw "Unsupported arch: ${stdenv.hostPlatform.system}";
  platform = if stdenv.hostPlatform.isDarwin then "darwin-${arch}" else "linux-${arch}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "github-copilot-cli";
  version = "1.0.105";

  src = fetchurl {
    url = "https://github.com/github/copilot-cli/releases/download/v${finalAttrs.version}/github-copilot-${finalAttrs.version}-${platform}.tgz";
    hash =
      {
        "aarch64-darwin" = "sha256-vzlNfC89zYHvqNS3rcrP5P10gQNgHTNLlIZ49n8A+lk=";
        "x86_64-linux" = "sha256-viD0oqaPwk2hSfYyiqSZMwm40NE/ruqeIr0GXSPvA7I=";
        "aarch64-linux" = "sha256-0SaVxefiAfhhgC/aroqy3lZceBxAUd2yyefkmN3vJ0Y=";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  nativeBuildInputs = [
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
    glib
    libsecret
    libpulseaudio
    onnxruntime
    onnxruntime-genai
  ];
  sourceRoot = "package";
  dontStrip = true;
  # computer.node requires GUI/media libraries (X11, pipewire, libei, libjpeg,
  # libpng) for screen-capture and input-simulation features that are not
  # relevant for CLI use; ignore those missing deps rather than fail the build
  # or pull in heavy dependencies.
  autoPatchelfIgnoreMissingDeps = [
    "libX11.so.6"
    "libXtst.so.6"
    "libjpeg.so.8"
    "libpng16.so.16"
    "libpipewire-0.3.so.0"
    "libei.so.1"
    "libwebkit2gtk-4.1.so.0"
    "libjavascriptcoregtk-4.1.so.0"
    "libgtk-3.so.0"
    "libgdk-3.so.0"
    "libcairo.so.2"
    "libgdk_pixbuf-2.0.so.0"
    "libsoup-3.0.so.0"
    "libwayland-client.so.0"
    "libdbus-1.so.3"
    "libxdo.so.3"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"/lib/github-copilot-cli
    cp -r * "$out"/lib/github-copilot-cli
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    runtime="$out/lib/github-copilot-cli/foundry-local-sdk/node_modules/foundry-local-sdk/prebuilds/linux-${arch}"
    ln -s ${lib.getLib onnxruntime}/lib/libonnxruntime.so.1 "$runtime/"
    ln -s ${lib.getLib onnxruntime-genai}/lib/libonnxruntime-genai.so "$runtime/"

    # Keep runtime installation in the store; model downloads remain in the user cache.
    ${lib.getExe nodejs} --input-type=module - "$out/lib/github-copilot-cli" <<'JS'
    import { readFileSync, writeFileSync } from 'node:fs';
    import { join } from 'node:path';

    for (const name of ['voice-server.js', 'voice-engine.worker.js']) {
      const path = join(process.argv[2], name);
      const source = readFileSync(path, 'utf8');
      const factory = /function (\w+)\(\)\{let \w+,\w+;return\{async inspect\(\)\{.*?return \w+=\w+,\w+\}\}\}/g;
      const matches = [...source.matchAll(factory)];
      if (matches.length !== 1) {
        throw new Error('Expected one voice runtime installer in ' + name + ', found ' + matches.length);
      }
      writeFileSync(path, source.replace(factory, (_, name) =>
        'function ' + name + '(){const location={corePath:new URL("./foundry-local-sdk/node_modules/foundry-local-sdk/prebuilds/linux-${arch}/libfoundry_local.so",import.meta.url).pathname};return{async inspect(){return{kind:"downloaded",location}},async install(){return location}}}'
      ));
    }
    JS
  ''
  + ''
    runHook postInstall
  '';

  postInstall = ''
    makeWrapper ${nodejs}/bin/node "$out"/bin/copilot \
      --add-flag "$out"/lib/github-copilot-cli/index.js \
      --add-flag --no-auto-update \
      --set-default NODE_NO_WARNINGS 1 \
      --set-default SSL_CERT_DIR ${cacert}/etc/ssl/certs \
      --prefix PATH : "${lib.makeBinPath [ bash ]}"
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${lib.getLib libpulseaudio}/lib \
      "$out/lib/github-copilot-cli/pvrecorder/node_modules/@picovoice/pvrecorder-node/lib/linux/${stdenv.hostPlatform.parsed.cpu.name}/pv_recorder.node"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "CLI client for GitHub Copilot";
    homepage = "https://github.com/github/copilot-cli";
    changelog = "https://github.com/github/copilot-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode # including contents of the prebuild directory
      binaryBytecode # including WASM files
      obfuscatedCode # including minified JavaScript
    ];
    maintainers = with lib.maintainers; [
      me-and
    ];
    mainProgram = "copilot";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
