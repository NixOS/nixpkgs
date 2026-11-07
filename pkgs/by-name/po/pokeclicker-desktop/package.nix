{
  lib,
  buildNpmPackage,
  dpkg,
  electron,
  fetchFromGitHub,
  fpm,
  makeWrapper,
  nix-update-script,
}:

buildNpmPackage (_finalAttrs: {
  pname = "pokeclicker-desktop";
  version = "1.2.0-unstable-2022-12-31";

  src = fetchFromGitHub {
    owner = "RedSparr0w";
    repo = "Pokeclicker-desktop";
    # The release artifacts include two follow-up icon commits made after the
    # tag. Switch to using `tag` instead of `rev` after 1.2.1+.
    rev = "0d35925a70241bb4b507ea2f606b37eb87d06220";
    hash = "sha256-sGIH8E8yZNy9kcQSjWygF3PYykIPUrlfHQxdSTTP8SE=";
  };

  npmDepsHash = "sha256-FA5S4u6XV8B5474fwcORwlZq+eo5FsdMGDQuM+fesaQ=";

  __structuredAttrs = true;

  # Required solely for discord-rpc's optional register-scheme Git dependency,
  # which has an install script but no lock file.
  forceGitDeps = true;

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    USE_SYSTEM_FPM = "true";
  };

  nativeBuildInputs = [
    dpkg
    fpm
    makeWrapper
  ];

  postPatch = ''
    # The application itself is updated through Nix. The separately downloaded
    # game data continues to use the upstream runtime updater.
    substituteInPlace src/main.js \
      --replace-fail 'autoUpdater.checkForUpdatesAndNotify()' '// Desktop updates are managed by Nix.'
  '';

  buildPhase = ''
    runHook preBuild

    # Build upstream's deb target so Electron Builder remains the source of
    # truth for the desktop entry and complete icon layout extracted below.
    npm exec electron-builder -- \
      --linux \
      --config.electronDist=${electron.dist} \
      --config.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/pokeclicker-desktop $out/bin
    cp -r dist/*-unpacked/resources/app.asar* $out/share/pokeclicker-desktop

    deb_root=$(mktemp -d)
    dpkg-deb --extract dist/*.deb "$deb_root"
    cp -r "$deb_root/usr/share/applications" "$out/share"
    cp -r "$deb_root/usr/share/icons" "$out/share"

    substituteInPlace "$out/share/applications/pokeclicker-desktop.desktop" \
      --replace-fail '/opt/PokéClicker/pokeclicker-desktop' "$out/bin/pokeclicker-desktop"

    makeWrapper ${lib.getExe electron} $out/bin/pokeclicker-desktop \
      --add-flags $out/share/pokeclicker-desktop/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --inherit-argv0

    runHook postInstall
  '';

  # TODO remove `extraArgs` after 1.2.1+
  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "Desktop client for PokeClicker";
    homepage = "https://github.com/RedSparr0w/Pokeclicker-desktop";
    changelog = "https://github.com/RedSparr0w/Pokeclicker-desktop/releases/tag/v1.2.0"; # TODO use `finalAttrs.src.tag` after 1.2.1+
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ ilkecan ];
    platforms = lib.platforms.linux;
    mainProgram = "pokeclicker-desktop";
  };
})
