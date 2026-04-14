{
  lib,
  stdenv,
  copyDesktopItems,
  desktopToDarwinBundle,
  fetchFromGitHub,
  fetchYarnDeps,
  makeBinaryWrapper,
  makeDesktopItem,
  yarnBuildHook,
  yarnConfigHook,

  electron,
  git,
  git-lfs,
  node-gyp,
  nodejs,
  pkg-config,
  python3,
  typescript,
  zip,

  gnome-keyring,
  libsecret,
  curl,

  _experimental-update-script-combinators,
  nix-update-script,
}:

let
  inherit (stdenv.hostPlatform.node) arch platform;
  cacheRootHash = "sha256-mR5geiPPAv+oK1efT3pMfnUT1keOxB8Ge1yiq4hLtj0=";
  cacheAppHash = "sha256-y8brlXwBur2RqJD8xlpA9ivg09xIDBuAtolhyzYkRx4=";
in

stdenv.mkDerivation (finalAttrs: {
  pname = "github-desktop";
  version = "3.5.7";

  src = fetchFromGitHub {
    owner = "desktop";
    repo = "desktop";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-H6FPMp+Y3PmRtuaOVX+8Yd3a5JA+zvLeGeLp99X1+y0=";
    fetchSubmodules = true;
    postCheckout = "git -C $out rev-parse HEAD > $out/.gitrev";
  };

  yarnBuildScript = "build:prod";

  buildInputs = [
    gnome-keyring
    libsecret
    curl
  ];

  nativeBuildInputs = [
    copyDesktopItems
    makeBinaryWrapper
    yarnBuildHook
    yarnConfigHook

    git
    nodejs
    node-gyp
    pkg-config
    python3
    # desktop-notifications build doesn't pick up tsc from node_modules for some reason
    typescript
    zip
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin desktopToDarwinBundle;

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    npm_config_nodedir = electron.headers;
  };

  cacheRoot = fetchYarnDeps {
    name = "${finalAttrs.pname}-cache-root";
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = cacheRootHash;
  };

  cacheApp = fetchYarnDeps {
    name = "${finalAttrs.pname}-cache-app";
    yarnLock = finalAttrs.src + "/app/yarn.lock";
    hash = cacheAppHash;
  };

  dontYarnInstallDeps = true;

  postConfigure = ''
    yarnOfflineCache="$cacheRoot" runHook yarnConfigHook

    pushd app
    yarnOfflineCache="$cacheApp" runHook yarnConfigHook
    popd

    yarn --cwd app/node_modules/desktop-notifications run install

    # use git from nixpkgs instead of an automatically downloaded one by dugite
    makeWrapper ${lib.getExe git} app/node_modules/dugite/git/bin/git \
      --prefix PATH : ${lib.makeBinPath [ git-lfs ]}


    # exception: printenvz needs `node-gyp` configure first for some reason
    pushd node_modules/printenvz
    node node_modules/.bin/node-gyp configure
    popd

    declare -a natives=(
      app/node_modules/fs-admin
      app/node_modules/keytar
      app/node_modules/desktop-trampoline
      app/node_modules/windows-argv-parser
      node_modules/printenvz
    )
    for native in "''${natives[@]}"; do
      yarn --offline --cwd $native build
    done

    # exception: desktop-trampoline doesn't include `node-gyp rebuild` in its build script anymore
    pushd app/node_modules/desktop-trampoline
    node-gyp rebuild
    popd

    yarn compile:script

    touch electron
    zip -0Xqr electron-v${electron.version}-${platform}-${arch}.zip electron
    rm electron

    substituteInPlace script/build.ts \
      --replace-fail "return packager({" "return packager({electronZipDir:\"$(pwd)\",electronVersion: \"${electron.version}\","
  '';

  preBuild = ''
    export CIRCLE_SHA1="$(cat .gitrev)"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "github-desktop";
      desktopName = "GitHub Desktop";
      comment = "Focus on what matters instead of fighting with Git";
      exec = "github-desktop %u";
      icon = "github-desktop";
      mimeTypes = [
        "x-scheme-handler/x-github-client"
        "x-scheme-handler/x-github-desktop-auth"
        "x-scheme-handler/x-github-desktop-dev-auth"
      ];
      terminal = false;
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/github-desktop

    # transpose [name][size] into [size][name]
    for icon in app/static/logos/*.png; do
      size="$(basename "$icon" .png)"
      install -Dm444 "$icon" -T "$out/share/icons/hicolor/$size/github-desktop.png"
    done

    cp -r dist/*/resources $out/share/github-desktop

    makeWrapper ${lib.getExe electron} $out/bin/github-desktop \
      --add-flag $out/share/github-desktop/resources/app \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --inherit-argv0

    mkdir -p $out/share/icons/hicolor/512x512/apps
    ln -s $out/share/github-desktop/resources/app/static/icon-logo.png $out/share/icons/hicolor/512x512/apps/github-desktop.png

    runHook postInstall
  '';

  passthru = {
    inherit (finalAttrs) cacheRoot cacheApp;
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script {
        extraArgs = [
          "--version-regex"
          ''^release-(\d\.\d\.\d)$''
        ];
      })
      # TODO: in the future, use `nix-update --custom-dep`.
      ./update-yarn-caches.sh
    ];
  };

  meta = {
    description = "GUI for managing Git and GitHub";
    homepage = "https://desktop.github.com";
    changelog = "https://desktop.github.com/release-notes";
    downloadPage = "https://desktop.github.com/download";
    license = lib.licenses.mit;
    mainProgram = "github-desktop";
    maintainers = with lib.maintainers; [ dtomvan ];
    inherit (electron.meta) platforms;
  };
})
