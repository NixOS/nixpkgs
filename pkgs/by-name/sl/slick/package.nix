{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  bun,
  nodejs_24,
  jq,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  electron_45,
  git,
  slack,
}:
let
  electron = electron_45;

  slackResources =
    if stdenv.hostPlatform.isDarwin then
      "${slack}/Applications/Slack.app/Contents/Resources"
    else
      "${slack}/lib/slack/resources";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "slick";
  version = "2.0.160";

  src = fetchFromGitHub {
    owner = "3kh0";
    repo = "slick";
    tag = "v${lib.versions.patch finalAttrs.version}";
    hash = "sha256-Z9kE/em0m+Kzj2AD3xvtW/EGt0J3FBEh/+/3KAuQY0Y=";
  };

  strictDeps = true;
  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  postPatch = ''
    substituteInPlace src/desktop/slackUpdater.ts \
      --replace-fail "if (!MAC) {" "if (true) {"
  '';

  node-modules = callPackage ./node-modules.nix { slick = finalAttrs.finalPackage; };

  nativeBuildInputs = [
    bun
    nodejs_24
    jq
    makeWrapper
    copyDesktopItems
  ];

  env = {
    SLICK_BUILD = lib.versions.patch finalAttrs.version;
    SLICK_VERSION = finalAttrs.version;
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  };

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.node-modules} node_modules
    chmod -R u+w node_modules
    patchShebangs node_modules

    runHook postConfigure
  '';

  preBuild = ''
    upstreamElectron=$(jq -r '.devDependencies.electron' package.json | tr -d '^~' | cut -d. -f1)
    if [ "$upstreamElectron" != "${lib.versions.major electron.version}" ]; then
      echo "ERROR: upstream expects Electron $upstreamElectron, nixpkgs provides ${electron.version}"
      exit 1
    fi
  '';

  buildPhase = ''
    runHook preBuild

    node scripts/build.ts desktop

    runHook postBuild
  '';

  doCheck = true;

  nativeCheckInputs = [ git ];

  checkPhase = ''
    runHook preCheck

    export NODE_OPTIONS='--test-skip-pattern="code pack"${lib.optionalString stdenv.hostPlatform.isDarwin " --test-skip-pattern=\"stages and waits for explicit apply\" --test-skip-pattern=\"installs a staged update\" --test-skip-pattern=\"failed provenance cleans staging\""}'
    npm test

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    resources=$out/share/slick/resources
    mkdir -p $resources
    cp -r dist/desktop $resources/app
    cp -r dist/desktop/slick.js dist/desktop/monaco $resources/
    cp -r themes $resources/themes
    cp -r assets/tray $resources/tray

    for size in 16 32 64 128 256 512 1024; do
      install -Dm644 assets/desktop-linux/$size.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/dev.slick.Slick.png
    done
    install -Dm644 assets/desktop.svg $out/share/icons/hicolor/scalable/apps/dev.slick.Slick.svg

    makeWrapper ${lib.getExe electron} $out/bin/slick \
      --add-flags $resources/app \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set-default SLICK_SLACK_RESOURCES ${slackResources} \
      --set SLICK_RESOURCES_PATH $resources \
      --set SLICK_CODE_UPDATES 0

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "dev.slick.Slick";
      desktopName = "Slick";
      genericName = "Slack client";
      comment = finalAttrs.meta.description;
      exec = "slick %U";
      icon = "dev.slick.Slick";
      startupWMClass = "Slick";
      mimeTypes = [ "x-scheme-handler/slack" ];
      categories = [
        "Network"
        "InstantMessaging"
        "Chat"
      ];
    })
  ];

  meta = {
    description = "Slack desktop client mod adding plugins and themes";
    homepage = "https://slickclient.net/";
    changelog = "https://github.com/3kh0/slick/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ first-uninteresting-username ];
    mainProgram = "slick";
    inherit (slack.meta) platforms;
    broken =
      slack ? electronVersion
      && lib.versions.major slack.electronVersion != lib.versions.major electron.version;
  };
})
