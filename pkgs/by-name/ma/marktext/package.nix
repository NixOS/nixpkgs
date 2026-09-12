{
  stdenv,
  fetchFromGitHub,
  lib,
  fetchPnpmDeps,
  pnpm_10,
  pnpmConfigHook,
  nodejs,
  python3,
  node-gyp,
  libx11,
  xorgproto,
  libxkbfile,
  fontconfig,
  node-gyp-build,
  pkg-config,
  libsecret,
  makeWrapper,
  electron,
  nix-update-script,
}:
let
  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "marktext";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "marktext";
    repo = "marktext";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i1CjwRndcDUNpoMUPZ9U2TI/OsSX/WH8zXgEMHy338k=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit pnpm;
    inherit (finalAttrs) src version;
    pname = "marktext-monorepo";

    fetcherVersion = 4;
    hash = "sha256-PNFWviNG77Bfs0R08jCUDVQ/1O/1Q82iLWK+2tYLHg0=";
    pnpmInstallFlags = [ "--no-frozen-lockfile" ];
  };

  nativeBuildInputs = [
    pnpmConfigHook
    makeWrapper
    (python3.withPackages (ps: with ps; [ packaging ]))
    pkg-config
    electron
    nodejs
    node-gyp
    node-gyp-build
  ];

  buildInputs = [
    fontconfig
    xorgproto
    libsecret
    libx11
    libxkbfile
    pnpm
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # Patch i18n.ts before building
  postPatch = ''
    # Fix static/locales folder location
    substituteInPlace packages/desktop/src/common/i18n.ts \
      --replace-fail \
        "process.resourcesPath, 'static', 'locales'" \
        "__dirname, '..', '..', 'static', 'locales'"
  '';

  buildPhase = ''
    runHook preBuild

    # Need for electron-rebuild
    export npm_config_nodedir=${nodejs}

    # Generate minified locale files
    pnpm run minify-locales

    pnpm run build

    # Rebuild native modules
    pnpm exec electron-rebuild -f --module-dir packages/desktop

    pnpm exec electron-builder \
      --dir \
      --projectDir packages/desktop \
      --config electron-builder.yml \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version}

    # Inject static folder into the asar
    pushd dist/*-unpacked
    pnpm exec asar extract resources/app.asar app-tmp
    cp -a ../../packages/desktop/static app-tmp/static
    pnpm exec asar pack app-tmp resources/app.asar
    rm -rf app-tmp
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/marktext $out/{bin,share}

    install -Dm644 packages/desktop/build/linux/marktext.desktop \
      $out/share/applications/marktext.desktop

    # Copy the built app
    cp -r dist/*-unpacked/{locales,resources{,.pak}} $out/lib/marktext

    pushd packages/desktop/build/icons/
    find -maxdepth 1 -mindepth 1 -type d -exec install -DT {}/marktext.png $out/share/icons/hicolor/{}/apps/marktext.png \;
    find -maxdepth 1 -mindepth 1 -type d -exec install -DT {}/md.png $out/share/icons/hicolor/{}/apps/md.png \;
    popd

    makeWrapper ${lib.getExe electron} "$out/bin/marktext" \
      --add-flags "$out/lib/marktext/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --inherit-argv0

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "Simple and elegant markdown editor, available for Linux, macOS and Windows";
    homepage = "https://www.marktext.me";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      nh2
      eduarrrd
      bot-wxt1221
    ];
    platforms = lib.platforms.linux;
    mainProgram = "marktext";
  };
})
