{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  bun,
  nodejs,
  electron_42,
  cacert,
  git,
  makeWrapper,
  mpv,
  ffmpeg,
  unzip,
  writableTmpDirAsHomeHook,
  swift,
  stdenvNoCC,
}:

let
  electron = electron_42;

  mkBunDeps =
    {
      finalAttrs,
      name,
      sourceRoot ? finalAttrs.src.name,
      hashes,
    }:
    stdenvNoCC.mkDerivation {
      pname = "${finalAttrs.pname}-${name}-deps";
      inherit (finalAttrs) version src;

      nativeBuildInputs = [
        bun
        cacert
        git
        writableTmpDirAsHomeHook
      ];

      inherit sourceRoot;

      dontConfigure = true;
      dontFixup = true;

      buildPhase = ''
        runHook preBuild
        export GIT_SSL_CAINFO="${cacert}/etc/ssl/certs/ca-bundle.crt"
        export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
        bun install --frozen-lockfile --ignore-scripts --no-save --no-progress
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        mkdir -p $out
        cp -r node_modules $out/
        runHook postInstall
      '';

      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
      outputHash =
        hashes.${stdenvNoCC.hostPlatform.system}
          or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
    };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "subminer";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "ksyasuda";
    repo = "SubMiner";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-ScNs0+nqYv1EYC4jTiwGc+WNo3CUE9iLdXn+IH7A1Z4=";
  };

  rootDeps = mkBunDeps {
    inherit finalAttrs;
    name = "root";
    hashes = {
      aarch64-darwin = "sha256-/MqLFgtlPwFevwcaIX61EyGaJsH0+Txd2KnW7IhTiQU=";
      x86_64-linux = "sha256-WY99Z/mpFQtzX5Cxm88eWwTk4qx16eWvDcpOnB2MGWs=";
    };
  };

  statsDeps = mkBunDeps {
    inherit finalAttrs;
    name = "stats";
    sourceRoot = "${finalAttrs.src.name}/stats";
    hashes = {
      aarch64-darwin = "sha256-WH5e9G8Q6EtwNBMSm4YtEswkdxUNHOOFJG0Vsx7Zb+8=";
      x86_64-linux = "sha256-vDvJPjHh6bPMZp77vRexWPmfHU5AiigDMMdiemigrIc=";
    };
  };

  texthookerDeps = mkBunDeps {
    inherit finalAttrs;
    name = "texthooker";
    sourceRoot = "${finalAttrs.src.name}/vendor/texthooker-ui";
    hashes = {
      aarch64-darwin = "sha256-y06z7KaPsbbTgLOmuckrK8zBPQPb4JuWHdIRhZcNRf0=";
      x86_64-linux = "sha256-PFkxxn/rof6ZRIrSEMLGt/wXXl5cjO39H/uGMH0kPes=";
    };
  };

  yomitanDeps = mkBunDeps {
    inherit finalAttrs;
    name = "yomitan";
    sourceRoot = "${finalAttrs.src.name}/vendor/subminer-yomitan";
    hashes = {
      aarch64-darwin = "sha256-merBEVXaNxC5kpqkWzed68+NlMVGm1gz2vvvlxtpbIo=";
      x86_64-linux = "sha256-NbXmR7jE4u3mb2MMJYA7zkJOz04cKvs40Nu+qtiannE=";
    };
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    bun
    nodejs
    makeWrapper
    unzip
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    swift
  ];

  env.SUBMINER_YOMITAN_ALLOW_MISSING_GIT = "1";

  buildPhase = ''
    runHook preBuild

    cp -r ${finalAttrs.rootDeps}/node_modules ./node_modules
    cp -r ${finalAttrs.statsDeps}/node_modules stats/node_modules
    cp -r ${finalAttrs.texthookerDeps}/node_modules vendor/texthooker-ui/node_modules
    cp -r ${finalAttrs.yomitanDeps}/node_modules vendor/subminer-yomitan/node_modules

    chmod -R u+w node_modules
    chmod -R u+w stats/node_modules
    chmod -R u+w vendor/texthooker-ui/node_modules
    chmod -R u+w vendor/subminer-yomitan/node_modules

    patchShebangs node_modules
    patchShebangs stats/node_modules
    patchShebangs vendor/texthooker-ui/node_modules
    patchShebangs vendor/subminer-yomitan/node_modules

    # The mpv plugin must spawn the wrapper, not the raw Electron binary, so the app path is present.
    substituteInPlace src/main.ts \
      --replace-fail '      process.execPath,' \
                     "      '$out/libexec/subminer-app'," \
      --replace-fail 'binaryPath: config.mpv.subminerBinaryPath' \
                     "binaryPath: '$out/libexec/subminer-app'" \
      --replace-fail 'appExePath: process.execPath' \
                     "appExePath: '$out/libexec/subminer-app'"
    substituteInPlace src/main-entry.ts \
      --replace-fail '      process.execPath,' \
                     "      '$out/libexec/subminer-app',"
    substituteInPlace src/main-entry-launch-config.ts \
      --replace-fail 'binaryPath: config.mpv.subminerBinaryPath' \
                     "binaryPath: '$out/libexec/subminer-app'"

    # prepare-build-assets.mjs needs it for swiftc output.
    mkdir -p dist/scripts

    bun run --cwd vendor/texthooker-ui build
    bun run build

    substituteInPlace dist/launcher/subminer \
      --replace-fail "$PWD/launcher" "$out/share/subminer/dist/launcher"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/subminer/stats
    cp -r dist          $out/share/subminer/
    cp -r build         $out/share/subminer/
    cp -r stats/dist    $out/share/subminer/stats/dist
    cp -r vendor        $out/share/subminer/
    cp -r assets        $out/share/subminer/
    cp -r plugin        $out/share/subminer/
    cp -r node_modules  $out/share/subminer/
    cp package.json     $out/share/subminer/

    # Remove testcase and compiletime deps to reduce size
    find $out/share/subminer/dist -type f \( -name '*.map' -o -name '*.test.*' -o -name '*.type-test.*' \) -delete
    find $out/share/subminer/dist -type d -name __tests__ -prune -exec rm -rf {} +

    rm -rf $out/share/subminer/vendor/subminer-yomitan
    rm -rf $out/share/subminer/vendor/texthooker-ui/{src,node_modules,.svelte-kit,.vscode,public}
    rm -f $out/share/subminer/vendor/texthooker-ui/{README.md,package.json,package-lock.json}
    rm -f $out/share/subminer/vendor/texthooker-ui/tsconfig*.json

    mkdir -p $out/share/subminer/scripts
    if [ -f dist/scripts/get-mpv-window-macos ]; then
      cp dist/scripts/get-mpv-window-macos $out/share/subminer/scripts/
    elif [ -f dist/scripts/get-mpv-window-macos.swift ]; then
      cp dist/scripts/get-mpv-window-macos.swift $out/share/subminer/scripts/
    fi

    makeWrapper ${lib.getExe electron} $out/libexec/subminer-app \
      --add-flags "$out/share/subminer" \
      --add-flags "--start" \
      --set SUBMINER_BINARY_PATH "$out/libexec/subminer-app" \
      --set SUBMINER_MPV_PATH "${lib.getExe mpv}" \
      --prefix PATH : ${
        lib.makeBinPath [
          mpv
          ffmpeg
        ]
      }

    makeWrapper ${lib.getExe bun} $out/bin/subminer \
      --add-flags "$out/share/subminer/dist/launcher/subminer" \
      --set SUBMINER_BINARY_PATH "$out/libexec/subminer-app" \
      --set SUBMINER_MPV_PATH "${lib.getExe mpv}" \
      --prefix PATH : ${
        lib.makeBinPath [
          mpv
          ffmpeg
        ]
      }

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dm644 assets/SubMiner-square.png \
        $out/share/icons/hicolor/1024x1024/apps/subminer.png
      install -Dm644 ${./subminer.desktop} \
        $out/share/applications/subminer.desktop
    ''}

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p "$out/Applications/SubMiner.app/Contents/MacOS"
      install -Dm644 ${
        replaceVars ./Info.plist { version = finalAttrs.version; }
      } "$out/Applications/SubMiner.app/Contents/Info.plist"
      install -Dm644 assets/SubMiner-square.png \
        "$out/Applications/SubMiner.app/Contents/Resources/SubMiner.png"

      makeWrapper "$out/bin/subminer" \
        "$out/Applications/SubMiner.app/Contents/MacOS/SubMiner" \
        --add-flags "app" \
        --add-flags "--background"
    ''}

    runHook postInstall
  '';

  meta = {
    description = "All-in-one sentence mining overlay with AnkiConnect and dictionary integration for mpv";
    homepage = "https://github.com/ksyasuda/SubMiner";
    changelog = "https://github.com/ksyasuda/SubMiner/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "subminer";
    maintainers = [ lib.maintainers.mslxl ];
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
  };
})
