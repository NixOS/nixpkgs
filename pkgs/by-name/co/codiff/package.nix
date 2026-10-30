{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_12,
  nodejs,
  node-gyp,
  python3,
  pkg-config,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  installShellFiles,
  imagemagick,
  electron_45,
  git,
  libx11,
  libxkbfile,
  xdg-utils,
  nix-update-script,
  withAutoHideMenuBar ? false,
}:
let
  electron = electron_45;
  runtimePath = lib.makeBinPath [
    git
    xdg-utils
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "codiff";
  version = "1.18.3";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "nkzw-tech";
    repo = "codiff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ku/PyX0LxyNqPoldyJmiU4FSnHQtyboNCX04028/Ybc=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_12;
    fetcherVersion = 5;
    hash = "sha256-/3RZNEZ8+K/NB7Rengc2+y2DR2hKV+vQM9+VLv8tZ/E=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_12
    node-gyp
    python3
    pkg-config
    makeWrapper
    copyDesktopItems
    installShellFiles
    imagemagick
  ];

  buildInputs = [
    libx11
    libxkbfile
  ];

  # Launch the nixpkgs Electron wrapper, which already passes the app directory,
  # and never load a local dev server in place of the bundled renderer
  postPatch = ''
    substituteInPlace bin/codiff.js \
      --replace-fail "const { default: electron } = await import('electron');" \
        "const electron = '${placeholder "out"}/lib/codiff/codiff-app';" \
      --replace-fail "spawn(electron, [root], {" "spawn(electron, [], {" \
      --replace-fail " || (await detectDevServer(DEV_SERVER_URL))" ""

    # The in-app terminal helper would link the bare script, which needs a system node
    substituteInPlace electron/main/terminal-helper.cjs \
      --replace-fail "join(root, 'bin/codiff.js')" "'${placeholder "out"}/bin/codiff'"
  ''
  + lib.optionalString withAutoHideMenuBar ''
    substituteInPlace electron/main.cjs \
      --replace-fail "autoHideMenuBar: process.platform !== 'linux'," "autoHideMenuBar: true,"
  '';

  buildPhase = ''
    runHook preBuild

    pnpm exec vp build

    # Only keep the runtime dependencies for the native rebuild and install
    rm -rf node_modules {core,service,test,web}/node_modules
    pnpm install --offline --prod --ignore-scripts --frozen-lockfile --filter codiff

    export npm_config_nodedir=${electron.headers}
    for addon in node-pty native-keymap; do
      pushd node_modules/$addon
      node-gyp rebuild
      # gyp's build files would keep the toolchain in the runtime closure
      find build -mindepth 1 -maxdepth 2 ! -name Release ! -name '*.node' -exec rm -r {} +
      popd
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/codiff/core/lib
    cp -r package.json bin claude codex config dist electron opencode pi node_modules $out/lib/codiff
    cp core/lib/narrative-walkthrough-diff.cjs $out/lib/codiff/core/lib
    rm -r $out/lib/codiff/electron/__tests__
    # Addon sources and the 58M of macOS and Windows prebuilds
    rm -r $out/lib/codiff/node_modules/{node-addon-api,native-keymap/{deps,src},node-pty/{deps,node-addon-api,prebuilds,scripts,src,third_party}}
    # pnpm state files that record build-time paths and timestamps
    rm -r $out/lib/codiff/node_modules/{.modules.yaml,.pnpm,.pnpm-workspace-state-v1.json}

    mkdir -p $out/share/icons/hicolor/512x512/apps
    magick electron/icons/icon.png -resize 512x512 \
      $out/share/icons/hicolor/512x512/apps/codiff.png

    makeWrapper ${lib.getExe electron} $out/lib/codiff/codiff-app \
      --suffix PATH : ${runtimePath} \
      --add-flags $out/lib/codiff \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
    makeWrapper ${lib.getExe electron} $out/bin/codiff \
      --set ELECTRON_RUN_AS_NODE 1 \
      --suffix PATH : ${runtimePath} \
      --add-flags $out/lib/codiff/bin/codiff.js

    installShellCompletion --cmd codiff \
      --bash <(node bin/codiff.js --completions bash) \
      --fish <(node bin/codiff.js --completions fish) \
      --zsh <(node bin/codiff.js --completions zsh)

    runHook postInstall
  '';

  # The CLI always opens the current directory, so start the app directly to let
  # the launcher reopen the last repository
  postFixup = ''
    substituteInPlace $out/share/applications/codiff.desktop \
      --replace-fail "Exec=codiff-app" "Exec=$out/lib/codiff/codiff-app"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "codiff";
      desktopName = "Codiff";
      genericName = "Diff Viewer";
      comment = finalAttrs.meta.description;
      exec = "codiff-app %U";
      icon = "codiff";
      startupWMClass = "codiff";
      categories = [
        "Development"
        "RevisionControl"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minimal local diff viewer for reviewing and committing Git changes";
    homepage = "https://github.com/nkzw-tech/codiff";
    changelog = "https://github.com/nkzw-tech/codiff/releases/tag/${finalAttrs.src.tag}";
    license = [
      lib.licenses.mit
      lib.licenses.ofl
    ];
    maintainers = [ lib.maintainers.th1nkk1d ];
    mainProgram = "codiff";
    platforms = [ "x86_64-linux" ];
  };
})
