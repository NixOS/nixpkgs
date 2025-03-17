{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  electron,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
}:
buildNpmPackage rec {
  pname = "slacky";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "andirsun";
    repo = "Slacky";
    tag = "v${version}";
    hash = "sha256-nDxmzZqi7xEe4hnY6iXJg+613lSKElWxvF3w8bRDW90=";
  };

  npmDepsHash = "sha256-9+4cxeQw2Elug+xIgzNvpaSMgDVlBFz/+TW1jJwDm40=";

  npmPackFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = [
    electron
    copyDesktopItems
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  postInstall = ''
    mkdir -p $out/share/icons
    ln -s $out/lib/node_modules/slacky/build/icons/icon.png $out/share/icons/slacky.png
    makeWrapper ${electron}/bin/electron $out/bin/slacky \
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
    changelog = "https://github.com/andirsun/Slacky/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ awwpotato ];
    platforms = [ "aarch64-linux" ];
    mainProgram = "slacky";
  };
}
