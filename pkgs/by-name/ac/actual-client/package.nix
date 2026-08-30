{
  lib,
  actual-server,
  copyDesktopItems,
  electron_42,
  imagemagick,
  jq,
  makeDesktopItem,
  makeWrapper,
  removeReferencesTo,
  stdenv,
}:
let
  electron = electron_42;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "actual-client";

  inherit (actual-server)
    srcs
    version
    sourceRoot
    offlineCache
    env
    patches
    ;
  inherit (actual-server.offlineCache) missingHashes;

  __structuredAttrs = true;
  strictDeps = true;

  postPatch =
    actual-server.postPatch
    +
    # bash
    ''
      cat <<< $(${lib.getExe jq} 'del(.build.beforePack, .build.electronFuses)' packages/desktop-electron/package.json) > packages/desktop-electron/package.json
    '';

  nativeBuildInputs = actual-server.nativeBuildInputs ++ [
    copyDesktopItems
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild

    # TODO: uncomment once actual updates their electron version to v42+
    # https://github.com/actualbudget/actual/issues/8767
    # verify electron version
    # upstreamElectronMajor=$(${lib.getExe jq} -r '.devDependencies.electron | match("[0-9]+").string' packages/desktop-electron/package.json)
    # if [[ "$upstreamElectronMajor" != "${lib.versions.major electron.version}" ]]; then
    #   echo "Electron major version mismatch: Actual expects $upstreamElectronMajor, nixpkgs provides ${electron.version}" >&2
    #   exit 1
    # fi

    export HOME=$(mktemp -d)

    # lage hashes source files via `git ls-tree HEAD`, so it needs a repo with
    # at least one commit.
    git -c init.defaultBranch=main init -q
    git add -A
    git -c user.email=nix@localhost -c user.name=nix commit -q --allow-empty -m "snapshot"

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

    # The shared electron package will be used so only install the application resources produced by electron-builder
    mkdir -p "$out/share/lib/actual/resources"
    cp -Pr --no-preserve=ownership \
      packages/desktop-electron/dist/*-unpacked/resources/{app.asar,app.asar.unpacked,extra-resources} \
      "$out/share/lib/actual/resources/"

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

    # We set ELECTRON_FORCE_IS_PACKAGED because Usually electron apps have
    # a different executable name. Since we use the nixpkgs electron, it thinks
    # it has no app packaged into it even though we do add the resources for
    # Actual.

    makeShellWrapper ${lib.getExe electron} "$out/bin/actual" \
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
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = [
      lib.maintainers.PerchunPak
    ];
  };
})
