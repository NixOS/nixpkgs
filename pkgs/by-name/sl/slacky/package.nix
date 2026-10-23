{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  electron,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "slacky";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "andirsun";
    repo = "Slacky";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Tx4UbvQV05ITFxBB5SyFx+jvxc0jpIvpHJ+hpgUy0t4=";
  };

  npmDepsHash = "sha256-UAnIaAh8UPciwrOP/06KQPj1sb/ItkByQKgJxGorNSw=";

  npmPackFlags = [
    "--ignore-scripts"
  ];

  makeCacheWritable = true;

  npmFlags = [
    "--legacy-peer-deps"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    copyDesktopItems
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  postInstall = ''
    mkdir -p $out/share/icons
    ln -s $out/lib/node_modules/slacky/build/icons/icon.png $out/share/icons/slacky.png
    makeWrapper ${lib.getExe electron} $out/bin/slacky \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --add-flags $out/lib/node_modules/slacky/
  '';

  desktopItems = lib.singleton (makeDesktopItem {
    name = "slacky";
    exec = "slacky %u";
    icon = "slacky";
    desktopName = "Slacky";
    comment = "An unofficial Slack desktop client for arm64 Linux";
    startupWMClass = "com.andersonlaverde.slacky";
    type = "Application";
    categories = [
      "Network"
      "InstantMessaging"
    ];
    mimeTypes = [
      "x-scheme-handler/slack"
    ];
  });

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unofficial Slack desktop client for arm64 Linux";
    homepage = "https://github.com/andirsun/Slacky";
    changelog = "https://github.com/andirsun/Slacky/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ da157 ];
    platforms = lib.platforms.linux;
    mainProgram = "slacky";
  };
})
