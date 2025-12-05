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
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "andirsun";
    repo = "Slacky";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IGxIybfAfab21+c6yNGxCXCpJ7jMnxpoCvXIkwwRick=";
  };

  npmDepsHash = "sha256-5hCQVQUK/zOL8/WwBOGHE8/t+WCJL1H5ThpshLQ6Ni8=";

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
