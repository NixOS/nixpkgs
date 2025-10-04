{
  lib,
  stdenv,
  nodejs,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  fetchFromGitHub,
  yarn-berry_4,
  python3,
  pkg-config,
  pango,
  cairo,
  pixman,
  libsecret,
  electron_36,
  xcbuild,
  buildPackages,
  callPackage,
  runCommand,
  libGL,
}:

let
  electron = electron_36;
  yarn-berry = yarn-berry_4;

  releaseData = lib.importJSON ./release-data.json;

  buildPlugin = import ./buildPlugin.nix;

  getPluginPatch =
    src: id:
    runCommand "${id}.diff" { } ''
      patch="${src}/packages/default-plugins/plugin-patches/${id}.diff"

      if [ -f "$patch" ]; then
        cp "$patch" "$out"
      else
        # create an empty patch file if it doesn't exist – can't check this from Nix code without IFD
        touch "$out"
      fi
    '';

  getDefaultPlugins = map (callPackage buildPlugin);
in

stdenv.mkDerivation (finalAttrs: {
  pname = "joplin-desktop";
  inherit (releaseData) version;

  passthru.updateScript = ./update.py;

  src = fetchFromGitHub {
    owner = "laurent22";
    repo = "joplin";
    tag = "v${finalAttrs.version}";
    postFetch = ''
      # there's a file with a weird name that causes a hash mismatch on darwin
      rm $out/packages/app-cli/tests/support/photo*
    '';
    inherit (releaseData) hash;
  };

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes postPatch;
    hash = releaseData.deps_hash;
  };

  # allows overriding to disable building the plugins
  defaultPlugins = getDefaultPlugins (
    lib.mapAttrsToList (
      id: plugin:
      plugin
      // {
        patches = [ (getPluginPatch finalAttrs.src id) ];
      }
    ) releaseData.plugins
  );

  buildInputs = [
    libGL
  ];

  nativeBuildInputs = [
    nodejs
    yarn-berry.yarn-berry-offline
    yarn-berry.yarnBerryConfigHook
    (python3.withPackages (ps: with ps; [ distutils ]))
    pkg-config
    pango
    cairo
    pixman
    libsecret
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    xcbuild
    buildPackages.cctools
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    copyDesktopItems
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

    # Disable scripts for now, so that yarnBerryConfigHook does not try to build anything
    # before we can patchShebangs additional paths (see buildPhase).
    # https://github.com/NixOS/nixpkgs/blob/3cd051861c41df675cee20153bfd7befee120a98/pkgs/by-name/ya/yarn-berry/fetcher/yarn-berry-config-hook.sh#L83
    YARN_ENABLE_SCRIPTS = 0;
  };

  postPatch = ''
    # Don't automatically build everything
    sed -i '/postinstall/d' package.json
    # Don't install onenote-converter subpackage deps
    sed -i '/onenote-converter/d' packages/{lib,app-desktop}/package.json
    # Don't build the default plugins, would require networking. We build them separately.
    sed -i "/'buildDefaultPlugins',/d" packages/app-desktop/gulpfile.ts
  '';

  buildPhase = ''
    runHook preBuild

    unset YARN_ENABLE_SCRIPTS

    for node_modules in packages/*/node_modules; do
      patchShebangs $node_modules
    done

    yarn config set enableInlineBuilds true

    echo "installing yarn dependencies..."
    yarn workspaces focus \
      root \
      @joplin/app-desktop

    echo "building workspaces..."
    yarn workspaces foreach -vi \
      --topological-dev \
      --recursive \
      --from @joplin/app-desktop \
      run build
    yarn workspaces foreach -vi \
      --parallel \
      --recursive \
      --from @joplin/app-desktop \
      run tsc

    # electronDist needs to be modifiable on Darwin
    cp -r ${electron.dist} electronDist
    chmod -R u+w electronDist
    electronDist="$PWD/electronDist"

    echo "bundling desktop application..."
    cd packages/app-desktop

    # copy over defaultPlugins
    ${lib.concatMapStringsSep "\n" (
      plugin: "install -Dt ./build/defaultPlugins ${plugin}/*.jpl"
    ) finalAttrs.defaultPlugins}

    # file is expected to be present for Linux build
    mkdir dist && touch dist/AppImage

    yarn gulp before-dist

    yarn run electronRebuild

    yarn run electron-builder \
      --dir \
      -c.electronDist="$electronDist" \
      -c.electronVersion=${electron.version} \
      -c.mac.identity=null

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      outdir="$out/share/joplin-desktop"
      mkdir -p "$outdir"

      cp -r dist/*unpacked/* "$outdir"

      for file in "$src/Assets/LinuxIcons"/*.png; do
        resolution=$(basename "$file" .png)
        install -Dm644 "$file" "$out/share/icons/hicolor/$resolution/apps/joplin.png"
      done

      makeWrapper "$outdir"/joplin $out/bin/joplin-desktop \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libGL ]}" \
        --add-flags "--no-sandbox" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-wayland-ime --ozone-platform=wayland --enable-features=WaylandWindowDecorations}}" \
        --inherit-argv0
    ''}

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications
      cp -r dist/mac*/Joplin.app $out/Applications
      makeWrapper $out/Applications/Joplin.app/Contents/MacOS/Joplin $out/bin/joplin-desktop
    ''}

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "joplin";
      desktopName = "Joplin";
      exec = "joplin-desktop %U";
      icon = "joplin";
      comment = "Joplin for Desktop";
      categories = [ "Office" ];
      startupWMClass = "@joplin/app-desktop";
      mimeTypes = [ "x-scheme-handler/joplin" ];
    })
  ];

  meta = with lib; {
    description = "Open source note taking and to-do application with synchronisation capabilities";
    mainProgram = "joplin-desktop";
    longDescription = ''
      Joplin is a free, open source note taking and to-do application, which can
      handle a large number of notes organised into notebooks. The notes are
      searchable, can be copied, tagged and modified either from the
      applications directly or from your own text editor. The notes are in
      Markdown format.
    '';
    homepage = "https://joplinapp.org";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [
      fugi
    ];
    platforms = electron.meta.platforms ++ lib.platforms.darwin;
  };
})
