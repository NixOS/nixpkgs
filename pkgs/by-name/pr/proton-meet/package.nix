{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  pnpm_12,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
  electron,
  zip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "proton-meet";
  version = "1.0.14";

  src = fetchFromGitHub {
    owner = "ProtonMail";
    repo = "WebClients";
    rev = "proton-meet-desktop@${finalAttrs.version}";
    hash = "sha256-lC3f3wKYUxIybSJsPYhkXqSOLvBcbR+Wd2jBUKkirG8=";
  };

  # Only install dependencies of the meet-desktop workspace (including its
  # workspace dependencies). The full monorepo lockfile requires packages that
  # are not publicly published (@proton/proton-foundation-search, @tpe/*),
  # which the meet-desktop dependency graph does not use.
  pnpmWorkspaces = [ "proton-meet-desktop..." ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_12;
    fetcherVersion = 5;
    inherit (finalAttrs) pnpmWorkspaces prePnpmInstall;
    hash = "sha256-H5GdlkxANIp7ycE5+1L3vnm4jY7pVIWFr19jHYprkts=";
  };

  # Runs during both the pnpm dependency fetch and the build's pnpm install.
  #
  # Upstream resolves several @proton and @protontech packages (bip39,
  # openpgp, mimemessage, tidy-url, ...) from their private Nexus instances in
  # the lockfile, even though the same versions are published to the public
  # npm registry. Rewrite the registry bases, keeping upstream's pinned
  # versions and integrity hashes.
  #
  # The trust_lockfile export skips pnpm 12's supply-chain policy check, which
  # would fetch registry metadata for every lockfile entry, including the
  # non-public ones (@proton/proton-foundation-search, @tpe/*).
  prePnpmInstall = ''
    export pnpm_config_trust_lockfile=true
    substituteInPlace .npmrc pnpm-lock.yaml \
      --replace-fail "https://nexus.protontech.ch/repository/foundation-npm/" "https://registry.npmjs.org/" \
      --replace-fail "https://nexus.protontech.ch/repository/web-npm-private-and-public/" "https://registry.npmjs.org/" \
      --replace-fail "https://nexus.protontech.ch/repository/meet-npm/" "https://registry.npmjs.org/"
  '';

  nativeBuildInputs = [
    nodejs
    pnpm_12
    pnpmConfigHook
    makeWrapper
    copyDesktopItems
    zip
  ];

  env = {
    # Build tags baked into the main bundle via the DefinePlugin in
    # applications/meet-desktop/webpack.main.config.ts. Set to the same tag
    # name upstream uses for its desktop releases.
    BUILD_TAG = "proton-meet-desktop@${finalAttrs.version}";
    MEET_TAG = "proton-meet-desktop@${finalAttrs.version}";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "proton-meet";
      desktopName = "Proton Meet";
      exec = "proton-meet %U";
      icon = "proton-meet";
      comment = "Proton's end-to-end encrypted video conferencing service";
      categories = [
        "Network"
        "AudioVideo"
        "VideoConference"
      ];
      mimeTypes = [ "x-scheme-handler/proton-meet" ];
      startupWMClass = "proton-meet";
    })
  ];

  postPatch = ''
    # The wrapper runs nixpkgs' electron, so process.resourcesPath would point
    # into electron's libexec directory and the loading/error pages would not
    # be found. Point it at the bundled resources instead. The only Linux
    # occurrences are the two in this file; squirrel.ts is Windows-only.
    substituteInPlace applications/meet-desktop/src/utils/view/viewManagement.ts \
      --replace-fail "process.resourcesPath" "'$out/share/proton-meet/resources'"
  '';

  buildPhase = ''
    runHook preBuild

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    pushd electron-dist
    zip -0Xqr ../electron.zip .
    popd
    cp electron.zip applications/meet-desktop/electron.zip
    rm -r electron-dist electron.zip

    # force @electron/packager to use our electron instead of downloading it
    substituteInPlace node_modules/@electron/packager/dist/packager.js \
      --replace-fail 'await this.getElectronZipPath(downloadOpts)' '"electron.zip"'

    # electron-forge determines the Electron version from node_modules. Make
    # it use the pinned Electron from nixpkgs instead.
    substituteInPlace node_modules/@electron-forge/core-utils/dist/electron-version.js \
      --replace-fail "return version" "return '${electron.version}'"

    # electron-forge's console output is squeezed into one narrow column if unset
    export CI="1"

    pnpm -C applications/meet-desktop run package

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/proton-meet
    # nixpkgs' electron ships its own locales and resources.pak, so only the
    # app's bundled resources (app.asar and extra resources) are needed.
    cp -r applications/meet-desktop/out/*-linux-*/resources $out/share/proton-meet/

    install -Dm644 applications/meet-desktop/assets/linux/icon.svg \
      $out/share/icons/hicolor/scalable/apps/proton-meet.svg
    install -Dm644 applications/meet-desktop/assets/linux/icon.png \
      $out/share/icons/hicolor/256x256/apps/proton-meet.png

    makeWrapper ${lib.getExe electron} $out/bin/proton-meet \
      --add-flags $out/share/proton-meet/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Desktop client for Proton's end-to-end encrypted video conferencing service";
    homepage = "https://proton.me/meet";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ felschr ];
    # limited to systems electron supports on Linux
    platforms = lib.intersectLists lib.platforms.linux electron.meta.platforms;
    mainProgram = "proton-meet";
  };
})
