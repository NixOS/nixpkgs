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
}:

let
  # pinned upstream
  electron = electron_36;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "github-desktop";
  version = "3.4.13";

  src = fetchFromGitHub {
    owner = "desktop";
    repo = "desktop";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-srXX49sXJnxa/7GQzP1pdJ77qeZbK1Ge8OPfrq3s5m8=";
    leaveDotGit = true;
    fetchSubmodules = true;
    postFetch = ''
      cd $out
      git rev-parse HEAD > .gitrev
      rm -rf .git
    '';
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
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    npm_config_nodedir = electron.headers;
  };

  cacheRoot = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-PhjMY4bAt+Prx8tmgGCZ7fhAyKhOUudrJO9K8yr7F18=";
  };

  cacheApp = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/app/yarn.lock";
    hash = "sha256-eW3G4saTbjRUexgg+n0z4EU1YtAgvSoW+uU0rNZZ1l0=";
  };

  dontYarnInstallDeps = true;

  postConfigure = ''
    yarnOfflineCache="$cacheRoot" yarnConfigHook

    pushd app
    yarnOfflineCache="$cacheApp" yarnConfigHook
    popd

    yarn --cwd app/node_modules/desktop-notifications run install

    # use git from nixpkgs instead of an automatically downloaded one by dugite
    echo > app/node_modules/dugite/script/download-git.js
    cp -r ${git} app/node_modules/dugite/git
    chmod -R +w app/node_modules/dugite/git

    for native in fs-admin keytar desktop-trampoline windows-argv-parser; do
      yarn --offline --cwd app/node_modules/$native build
    done

    yarn compile:script

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    pushd electron-dist
    zip -0Xqr ../electron.zip .
    popd

    rm -r electron-dist

    substituteInPlace node_modules/electron-packager/src/index.js \
      --replace-fail "await this.getElectronZipPath(downloadOpts)" "\"$(pwd)/electron.zip\""
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

    runHook postInstall
  '';

  meta = {
    description = "GUI for managing Git and GitHub";
    homepage = "https://desktop.github.com/";
    license = lib.licenses.mit;
    mainProgram = "github-desktop";
    maintainers = with lib.maintainers; [ dtomvan ];
    inherit (electron.meta) platforms;
  };
})
