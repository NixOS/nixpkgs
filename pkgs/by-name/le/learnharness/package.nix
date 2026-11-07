{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  electron_44,
  autoPatchelfHook,
  jetbrains-mono,
  source-sans,
  makeBinaryWrapper,
  makeDesktopItem,
  copyDesktopItems,
  nix-update-script,
}:

let
  electron = electron_44;
in
buildNpmPackage (finalAttrs: {
  pname = "learnharness";
  version = "0.3.8";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "amosblomqvist";
    repo = "learnharness";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VnkCjNWTpzXtZyc/IkkRQsg6tNm6jH+XbyVfEecbQjs=";
  };

  npmDepsHash = "sha256-7CcshvzUQrZ2anlaVTPZAbFVXIK2OExesikpyqRtO2c=";

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    NEXT_TELEMETRY_DISABLED = "1";
    # Keeps electron-builder from looking for a signing identity on Darwin
    CSC_IDENTITY_AUTO_DISCOVERY = "false";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
    copyDesktopItems
  ];

  # For the prebuilt sharp binaries from npm
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ (lib.getLib stdenv.cc.cc) ];

  postPatch = ''
    # next/font/google downloads the fonts during the build, so use the
    # copies from nixpkgs
    substituteInPlace app/layout.tsx \
      --replace-fail 'import { JetBrains_Mono, Source_Sans_3 } from "next/font/google";' \
        'import localFont from "next/font/local";' \
      --replace-fail 'JetBrains_Mono({ subsets: ["latin"], variable: "--font-jetbrains" })' \
        'localFont({ src: "./JetBrainsMono.ttf", weight: "100 800", variable: "--font-jetbrains" })' \
      --replace-fail 'Source_Sans_3({ subsets: ["latin"], variable: "--font-sans3" })' \
        'localFont({ src: "./SourceSans3.ttf", weight: "200 900", variable: "--font-sans3" })'
    cp "${jetbrains-mono}/share/fonts/truetype/JetBrainsMono[wght].ttf" app/JetBrainsMono.ttf
    cp ${source-sans}/share/fonts/truetype/SourceSans3VF-Upright.ttf app/SourceSans3.ttf

    # Updates come from nixpkgs, not electron-updater
    substituteInPlace electron/main.cjs \
      --replace-fail 'if (!app.isPackaged) {' 'if (true) {'
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # The shared Electron reports its own resources directory, so point the
    # shell at the installed server
    substituteInPlace electron/main.cjs --replace-fail \
      'path.join(process.resourcesPath, "server", "standalone", "server.js")' \
      "\"$out/share/learnharness/server/standalone/server.js\""

    # The shared Electron needs the app directory to start the browser
    # service helper, or it opens its default app instead
    substituteInPlace src/agent/subagents/headless.ts --replace-fail \
      'process.versions.electron ? ["--browser-service"]' \
      "process.versions.electron ? [\"$out/share/learnharness/app\", \"--browser-service\"]"
  '';

  postBuild = ''
    node scripts/build-server.mjs
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # Prebuilt sharp binaries for musl, which this libc cannot load
    rm -r .next/standalone/node_modules/@img/*musl*
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    # build/icon.icon needs Xcode's actool, so use the prebuilt icns instead
    npm exec electron-builder -- \
      --dir \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version} \
      -c.npmRebuild=false \
      -c.mac.icon=build/icon.icns \
      -c.mac.identity=null \
      -c.mac.notarize=false
  '';

  # Boots the server payload and probes its read-only API, as upstream does
  # before packaging.  On Linux it runs on the Electron that runs it later.
  doCheck = true;
  checkPhase = ''
    runHook preCheck
  ''
  + (
    if stdenv.hostPlatform.isLinux then
      ''
        ELECTRON_OVERRIDE_DIST_PATH=${electron.dist} node scripts/smoke-server.mjs --electron
      ''
    else
      ''
        node scripts/smoke-server.mjs
      ''
  )
  + ''
    runHook postCheck
  '';

  __darwinAllowLocalNetworking = true;

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/share/learnharness/{app/node_modules,server}
    cp -r electron package.json $out/share/learnharness/app
    cp -r node_modules/jose $out/share/learnharness/app/node_modules
    cp -r .next/standalone $out/share/learnharness/server
    install -Dm644 docs/compaction-accounting.md $out/share/learnharness/licenses/pi-compaction.md
    install -Dm644 build/icon.png $out/share/icons/hicolor/512x512/apps/learnharness.png

    makeBinaryWrapper ${lib.getExe electron} $out/bin/learnharness \
      --add-flags $out/share/learnharness/app \
      --inherit-argv0
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r dist/mac*/LearnHarness.app $out/Applications

    makeBinaryWrapper $out/Applications/LearnHarness.app/Contents/MacOS/LearnHarness $out/bin/learnharness
  ''
  + ''
    runHook postInstall
  '';

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "learnharness";
      desktopName = "LearnHarness";
      comment = finalAttrs.meta.description;
      exec = "learnharness %U";
      icon = "learnharness";
      startupWMClass = "learnharness";
      categories = [ "Education" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Agent harness for learning difficult things";
    homepage = "https://learnharness.ai";
    changelog = "https://github.com/amosblomqvist/learnharness/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      agpl3Only
      ofl # Bundled Computer Modern Unicode font
    ];
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "learnharness";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
