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
}:

let
  inherit (stdenv.hostPlatform.node) arch platform;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "github-desktop";
  version = "3.4.13";

  src = fetchFromGitHub {
    owner = "desktop";
    repo = "desktop";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-srXX49sXJnxa/7GQzP1pdJ77qeZbK1Ge8OPfrq3s5m8=";
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
    hash = "sha256-PhjMY4bAt+Prx8tmgGCZ7fhAyKhOUudrJO9K8yr7F18=";
  };

  cacheApp = fetchYarnDeps {
    name = "${finalAttrs.pname}-cache-app";
    yarnLock = finalAttrs.src + "/app/yarn.lock";
    hash = "sha256-eW3G4saTbjRUexgg+n0z4EU1YtAgvSoW+uU0rNZZ1l0=";
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


    for native in fs-admin keytar desktop-trampoline windows-argv-parser; do
      yarn --offline --cwd app/node_modules/$native build
    done

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
