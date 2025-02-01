{
  buildNpmPackage,
  lib,
  autoPatchelfHook,
  electron,
  fetchFromGitHub,
  gitUpdater,
  makeWrapper,
  ollama,
  pkg-config,
  stdenv,
  vips,
}:

buildNpmPackage rec {
  pname = "chatd";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "BruceMacD";
    repo = "chatd";
    rev = "v${version}";
    hash = "sha256-6z5QoJk81NEP115uW+2ah7vxpDz8XQUmMLESPsZT9uU=";
  };

  makeCacheWritable = true; # sharp tries to build stuff in node_modules
  ELECTRON_SKIP_BINARY_DOWNLOAD = true;

  npmDepsHash = "sha256-jvGvhgNhY+wz/DFS7NDtmzKXbhHbNF3i0qVQoFFeB0M=";

  dontNpmBuild = true; # missing script: build

  nativeBuildInputs = [
    makeWrapper
    electron
    autoPatchelfHook # for onnx libs
    pkg-config
  ];

  buildInputs = [
    stdenv.cc.cc.lib # for libstdc++.so, required by onnxruntime
    vips # or it will try to download from the Internet
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share}
    cp -r . $out/share/chatd

    for bin in ollama-darwin ollama-linux; do
      makeWrapper ${lib.getExe ollama} $out/share/chatd/src/service/ollama/runners/$bin
    done

    makeWrapper ${lib.getExe electron} $out/bin/chatd \
      --add-flags $out/share/chatd/src/index.js \
      --chdir $out/share/chatd \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1
    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace $out/share/chatd/node_modules/@xenova/transformers/src/env.js \
      --replace-fail "import fs from 'fs';" "import fs from 'fs';import os from 'os';" \
      --replace-fail 'path.dirname(path.dirname(url.fileURLToPath(import.meta.url)))' 'path.join(os.homedir(), ".cache", "chatd")'

    rm -rf $out/share/electron{,-winstaller} $(find $out -name 'win32')
    find $out/share/chatd/node_modules -name '*.exe' -or -name '*.dll' -or -name '*.pdb' -delete
    rm -rf ${
      lib.concatStringsSep " " (
        (lib.optional (!stdenv.isx86_64) "$out/share/chatd/node_modules/onnxruntime-node/bin/napi-v3/*/x64")
        ++ (lib.optional (
          !stdenv.isAarch64
        ) "$out/share/chatd/node_modules/onnxruntime-node/bin/napi-v3/*/arm64")
        ++ (lib.optional (
          !stdenv.isDarwin
        ) "$out/share/chatd/node_modules/onnxruntime-node/bin/napi-v3/darwin")
        ++ (lib.optional (
          !stdenv.isLinux
        ) "$out/share/chatd/node_modules/onnxruntime-node/bin/napi-v3/linux")
      )
    }
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Chat with your documents using local AI";
    homepage = "https://github.com/BruceMacD/chatd";
    changelog = "https://github.com/BruceMacD/chatd/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.lucasew ];
    mainProgram = "chatd";
    platforms = electron.meta.platforms;
  };
}
