{
  lib,
  actual-server,
  copyDesktopItems,
  electron_39,
  imagemagick,
  jq,
  makeDesktopItem,
  removeReferencesTo,
  stdenv,
}:
let
  electron = electron_39;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "actual-client";

  inherit (actual-server)
    srcs
    version
    sourceRoot
    offlineCache
    env
    ;
  inherit (actual-server.offlineCache) missingHashes;

  __structuredAttrs = true;
  strictDeps = true;

  postPatch =
    actual-server.postPatch
    +
    # bash
    ''
      # upstream had an issue, where binaries for x86 Mac had included blobs for
      # aarch (cross-compiling issue?) so they decided to recompile some
      # packages after `yarn install` for the right architecture. however, this
      # breaks build on Nix, and I doubt someone would cross-compile this
      # package using Nix
      cat <<< $(${lib.getExe jq} 'del(.build.beforePack)' packages/desktop-electron/package.json) > packages/desktop-electron/package.json
    '';

  nativeBuildInputs = actual-server.nativeBuildInputs ++ [
    copyDesktopItems
  ];

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)

    # rebuild better-sqlite3; copied from splayer package
    # we need to use headers from electron to avoid ABI mismatches.
    pushd node_modules/better-sqlite3
    npm run build-release --offline --nodedir="${electron.headers}"
    rm -rf build/Release/{.deps,obj,obj.target,test_extension.node}
    find build -type f -exec \
      ${lib.getExe removeReferencesTo} \
      -t "${electron.headers}" {} \;
    popd

    ./bin/package-electron --skip-translations --skip-exe-build

    pushd packages/desktop-electron/
    yarn build:dist
    yarn run electron-builder \
      --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version} \
      -c.mac.identity=null
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/lib/"
    cp -Pr --no-preserve=ownership packages/desktop-electron/dist/*-unpacked/ "$out/share/lib/actual/"

    mkdir icons
    declare -a icon_sizes=(16x16 32x32 48x48 64x64 128x128 256x256 512x512)
    for size in "''${icon_sizes[@]}"; do
      ${lib.getExe imagemagick} \
        -background none \
        packages/desktop-electron/icons/icon.png \
        -resize "!$size" \
        "icons/$size.png"
      install -D "icons/$size.png" \
        "$out/share/icons/hicolor/$size/apps/com.actualbudget.actual.png"
    done

    # I am setting ELECTRON_FORCE_IS_PACKAGED because for some weird reason,
    # electron always thinks it is not packaged
    # (it is checking if binary name is `electron`, and if it is, electron just
    # assumes it is not packaged. I have no idea what I do different from other
    # packages)
    # https://github.com/electron/electron/issues/35153#issuecomment-1202718531

    makeWrapper ${lib.getExe electron} "$out/bin/actual" \
      --add-flags "$out/share/lib/actual/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
      --set-default ELECTRON_IS_DEV 0 \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "com.actualbudget.actual";
      desktopName = "Actual";
      exec = "actual %U";
      terminal = false;
      type = "Application";
      icon = "com.actualbudget.actual";
      startupWMClass = "Actual";
      comment = "Super fast privacy-focused app for managing your finances";
      categories = [
        "Office"
        "Finance"
      ];
      keywords = [
        "Budget"
        "Finance"
        "Money"
        "Expenses"
        "Savings"
      ];
    })
  ];

  passthru = {
    inherit (finalAttrs) offlineCache;
  };

  meta = {
    changelog = "https://actualbudget.org/docs/releases";
    description = "Super fast privacy-focused app for managing your finances";
    homepage = "https://actualbudget.org/";
    mainProgram = "actual";
    license = lib.licenses.mit;
    # I don't have a GUI Mac, so I am not confident in my ability to support darwin
    platforms = with lib.platforms; linux;
    maintainers = [
      lib.maintainers.PerchunPak
    ];
  };
})
