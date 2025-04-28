{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm,
  electron,
  jq,
  moreutils,
  gitMinimal,
  makeBinaryWrapper,
  copyDesktopItems,
  makeDesktopItem,
}:

let
  ferdium-recipes = stdenv.mkDerivation (finalAttrs: {
    pname = "ferdium-recipes";
    version = "0-unstable-2025-03-11";

    src = fetchFromGitHub {
      owner = "ferdium";
      repo = "ferdium-recipes";
      rev = "f8e9970e546dd695fa2132fa60cd234ac6da14c1";
      hash = "sha256-j+6XNX8D4+cMCy+hndkybwaDoRZy1CVp/Ar328Sx8sw=";
      leaveDotGit = true;
    };

    postPatch = ''
      ${jq}/bin/jq 'del(.engines) | del(.volta) | del(.packageManager) | del(."engine-strict")' package.json | ${moreutils}/bin/sponge package.json
    '';

    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs)
        pname
        version
        src
        postPatch
        ;
      hash = "sha256-QuIP6C/8iQhgxF8s9jQHgdsKtWGKatTzIH5suscl9EU=";
    };

    nativeBuildInputs = [
      nodejs
      pnpm.configHook
      gitMinimal
    ];

    buildPhase = ''
      runHook preBuild

      pnpm run package

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir $out
      cp -r archives $out/archives
      cp all.json $out/all.json

      runHook postInstall
    '';

    meta = lib.licenses.mit;
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ferdium";
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "ferdium";
    repo = "ferdium-app";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q9DRtD9li2zYIcdKTdwAmRF8j+yaLzi1Xahp8wv6YR8=";
    fetchSubmodules = true;
  };

  patches = [ ./pnpm-lock.patch ];

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail "24.13.3" "25.1.6"
    ${jq}/bin/jq 'del(.engines) | del(.volta) | del(.packageManager) | del(."engine-strict")' package.json | ${moreutils}/bin/sponge package.json
    cp -r ${ferdium-recipes}/archives recipes/archives
    cp ${ferdium-recipes}/all.json recipes/all.json
  '';

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      postPatch
      ;
    hash = "sha256-EYG8NmSWhvq9xZ0hAMrm3MtJah5x94wXy2jwjO1I9rM=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
    makeBinaryWrapper
    copyDesktopItems
  ];

  env = {
    GIT_BRANCH_NAME = finalAttrs.src.tag;
    PACKAGE_VERSION = finalAttrs.version;
    NODE_ENV = "production";
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    CI = "true";
  };

  buildPhase = ''
    runHook preBuild

    node esbuild.mjs
    cp build/index.js index.js
    pnpm exec electron-builder --linux --dir \
      --config electron-builder.yml \
      -c.electronDist=${electron}/libexec/electron \
      -c.electronVersion=${electron.version} \
      -c.afterSign="" \
      -c.beforeBuild="" \
      -c.npmRebuild=false || true

    runHook postBuild
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "ferdium";
      desktopName = "Ferdium";
      comment = "Desktop app bringing all your messaging services into one installable";
      exec = "ferdium %U";
      terminal = false;
      icon = "ferdium";
      startupWMClass = "Ferdium";
      categories = [
        "Network"
        "InstantMessaging"
      ];
      mimeTypes = [ "x-scheme-handler/ferdium" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/ferdium
    cp -r out/linux-unpacked/{resources,LICENSE*} $out/lib/ferdium
    install -Dm644 build-helpers/images/icons/1024x1024.png $out/share/pixmaps/ferdium.png
    makeWrapper ${lib.getExe electron} $out/bin/ferdium \
      --inherit-argv0 \
      --add-flags $out/lib/ferdium/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
      --set-default ELECTRON_IS_DEV 0

    runHook postInstall
  '';

  meta = {
    description = "All your services in one place built by the community";
    homepage = "https://ferdium.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ magnouvean ];
    platforms = lib.platforms.linux;
  };
})
