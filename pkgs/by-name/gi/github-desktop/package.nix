{
  lib,
  stdenv,
  copyDesktopItems,
  fetchFromGitHub,
  fetchYarnDeps,
  makeBinaryWrapper,
  makeDesktopItem,
  yarnBuildHook,
  yarnConfigHook,

  electron_36,
  git,
  node-gyp,
  nodejs,
  pkg-config,
  python3,
  typescript,
  zip,

  gnome-keyring,
  libsecret,
  curl,

  nix-update-script,
}:

let
  # pinned upstream
  electron = electron_36;
in

# This super fun yarn concoction was inspired by Toma's logseq package and
# partly my own figma-linux package
stdenv.mkDerivation (finalAttrs: {
  pname = "github-desktop";
  version = "3.5.2";

  src = fetchFromGitHub {
    owner = "desktop";
    repo = "desktop";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-pJNtQZFZ0OWL7Pg/NQlAoSyORGVt8NPYef4cH4qFsfg=";
    fetchSubmodules = true;
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
    # desktop-notifications build doesn't pick up tsc from node_modules for
    # some reason
    typescript
    zip
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    # HACK: .git isn't available, so we provide a fake SHA through an
    # environment variable that's usually used by CircleCI to override the
    # commit hash in the build info
    # Source: https://github.com/desktop/desktop/blob/d4443aad6a5880a505222bccdb955cfeb6cec97a/app/git-info.ts#L82
    CIRCLE_SHA1 = "Nixpkgs";
  };

  cacheRoot = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-mrg82l8UEObGqI74CdRkFaztuHJ73RRRZW76n75CiQc=";
  };

  cacheApp = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/app/yarn.lock";
    hash = "sha256-FTKqpay0ysConZ0LoAAgSxiNJqO1te7G20XHRzQj0WE=";
  };

  cacheDesktopNotifications = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/vendor/desktop-notifications/yarn.lock";
    hash = "sha256-2Hd8baxxoseWVTSChP6AKIODOlOAHK0ALAGQr2gpoQM=";
  };

  dontYarnInstallDeps = true;

  postConfigure = ''
    yarnOfflineCache="$cacheRoot" yarnConfigHook

    pushd app
    yarnOfflineCache="$cacheApp" yarnConfigHook
    popd

    # This is insanely hacky, I don't even really understand why this has to be
    # the way it is...
    pushd app/node_modules/desktop-notifications
    yarnOfflineCache="$cacheDesktopNotifications" yarnConfigHook
    npm_config_nodedir="${nodejs}" yarn --offline install
    popd

    patchShebangs node_modules
    patchShebangs app/node_modules
    patchShebangs app/node_modules/desktop-notifications/node_modules

    # use git from nixpkgs instead of an automatically downloaded one by dugite
    echo > app/node_modules/dugite/script/download-git.js
    cp -r ${git} app/node_modules/dugite/git
    chmod -R +w app/node_modules/dugite/git

    # yarnConfigHook never runs lifecycle scripts so yeah this is what you get
    # I guess
    # This _has_ to be simpler no?
    for native in fs-admin keytar desktop-trampoline; do
      npm_config_nodedir="${nodejs}" yarn --offline --cwd app/node_modules/$native build
    done

    yarn compile:script

    # Because ts-loader isn't set and this package doesn't get compiled
    # automatically
    pushd app/node_modules/windows-argv-parser
    tsc
    popd

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    pushd electron-dist
    zip -0Xqr ../electron.zip .
    popd

    rm -r electron-dist

    substituteInPlace node_modules/electron-packager/src/index.js \
      --replace-fail "await this.getElectronZipPath(downloadOpts)" "\"$(pwd)/electron.zip\""
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "github-desktop";
      desktopName = "GitHub Desktop";
      comment = "Focus on what matters instead of fighting with Git";
      exec = "github-desktop %U";
      icon = "github-desktop";
      terminal = false;
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/github-desktop

    # transpose [name][size] into [size][name]
    for icon in app/static/logos/*.png; do
      basename="$(basename "$icon")"
      size="''${basename%.png}"

      install -Dm444 "$icon" -T "$out/share/icons/hicolor/$size/github-desktop.png"
    done

    cp -r dist/*/resources $out/share/github-desktop

    makeWrapper ${lib.getExe electron} $out/bin/github-desktop \
      --add-flag $out/share/github-desktop/resources/app \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --prefix PATH : "${lib.makeBinPath finalAttrs.buildInputs}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}" \
      --inherit-argv0

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      ''^release-(\d\.\d\.\d)$''
    ];
  };

  meta = {
    description = "GUI for managing Git and GitHub";
    homepage = "https://desktop.github.com/";
    license = lib.licenses.mit;
    mainProgram = "github-desktop";
    maintainers = with lib.maintainers; [ dtomvan ];
    inherit (electron.meta) platforms;
  };
})
