{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  electron_43,
  python3,
  python3Minimal,
  makeBinaryWrapper,
  makeDesktopItem,
  copyDesktopItems,
  cctools,
  xcbuild,
  darwin,
  nix-update-script,
}:

let
  electron = electron_43;
in
buildNpmPackage (finalAttrs: {
  pname = "maestro-desktop";
  version = "1.0.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "RunMaestro";
    repo = "Maestro";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h6eWxmbbx3JjHqIrwfhzc8AS034jDD04VOw6NkY+QiU=";
  };

  npmDepsHash = "sha256-+pKTEm118nrBLUfMqA0EULNu9ghTtOJ39jUHSuqZJcU=";

  # Dev-only native modules such as canvas and lzma-native try to download
  # prebuilt binaries; the runtime native modules are rebuilt in preBuild.
  npmRebuildFlags = [ "--ignore-scripts" ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    # Makes the upstream afterSign hook skip notarization on Darwin
    CSC_IDENTITY_AUTO_DISCOVERY = "false";
  };

  nativeBuildInputs = [
    # GYP's macOS support needs ctypes, which python3Minimal lacks
    (if stdenv.hostPlatform.isDarwin then python3 else python3Minimal)
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ copyDesktopItems ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
    xcbuild
    darwin.autoSignDarwinBinariesHook
  ];

  # On Linux the app runs on the shared Electron from nixpkgs, so
  # process.resourcesPath points at Electron's own resources instead of the
  # ones installed below.  TypeScript rejects a string literal as a bare
  # condition, hence the first substitution.
  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace src/main/cue/cue-cli-executor.ts \
      --replace-fail "if (process.resourcesPath)" "if (process.resourcesPath.length > 0)"
    grep -rlZ --include='*.ts' --exclude-dir=__tests__ 'process\.resourcesPath' src/main src/cli \
      | xargs -0 sed -i "s|process\.resourcesPath|'$out/share/maestro-desktop/resources'|g"
  '';

  preBuild = ''
    npm rebuild better-sqlite3 node-pty \
      --build-from-source \
      --nodedir=${electron.headers}
  '';

  postBuild = ''
    # Python helper scripts shipped by dependencies are unused at runtime, and
    # their patched shebangs would pull Python into the closure.
    find node_modules -name '*.py' -delete

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    npm exec electron-builder -- \
      --dir \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version} \
      -c.mac.identity=null
  '';

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/share/maestro-desktop
    cp -r release/linux-*unpacked/resources $out/share/maestro-desktop
    rm $out/share/maestro-desktop/resources/default_app.asar

    install -Dm644 build/icon.png $out/share/icons/hicolor/1024x1024/apps/maestro.png

    makeBinaryWrapper ${lib.getExe electron} $out/bin/maestro-desktop \
      --add-flags $out/share/maestro-desktop/resources/app.asar \
      --set ELECTRON_FORCE_IS_PACKAGED 1 \
      --inherit-argv0

    makeBinaryWrapper ${lib.getExe electron} $out/bin/maestro-cli \
      --add-flags $out/share/maestro-desktop/resources/maestro-cli.js \
      --set ELECTRON_RUN_AS_NODE 1
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r release/mac*/Maestro.app $out/Applications

    makeBinaryWrapper $out/Applications/Maestro.app/Contents/MacOS/Maestro $out/bin/maestro-desktop

    makeBinaryWrapper $out/Applications/Maestro.app/Contents/MacOS/Maestro $out/bin/maestro-cli \
      --add-flags $out/Applications/Maestro.app/Contents/Resources/maestro-cli.js \
      --set ELECTRON_RUN_AS_NODE 1
  ''
  + ''
    runHook postInstall
  '';

  # Electron derives the Wayland app ID and the registered maestro:// handler
  # from the package name, so the desktop entry is named to match.
  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "maestro";
      desktopName = "Maestro";
      comment = finalAttrs.meta.description;
      exec = "maestro-desktop %U";
      icon = "maestro";
      startupWMClass = "maestro";
      categories = [ "Development" ];
      mimeTypes = [ "x-scheme-handler/maestro" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Agent orchestration command center for AI coding agents";
    homepage = "https://runmaestro.ai";
    changelog = "https://github.com/RunMaestro/Maestro/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "maestro-desktop";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
