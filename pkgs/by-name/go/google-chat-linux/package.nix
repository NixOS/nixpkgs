{
  buildNpmPackage,
  copyDesktopItems,
  electron,
  fetchFromGitHub,
  lib,
  makeDesktopItem,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "google-chat-linux";
  version = "5.39.25-1";

  src = fetchFromGitHub {
    owner = "squalou";
    repo = "google-chat-linux";
    tag = version;
    hash = "sha256-hiTVENFuctQFFol1jQggPZRJ4JRe34OUSzmMJMu9zUs=";
  };

  npmDepsHash = "sha256-dAi3+OnYDIND+nBLXc8klXCQiiZ6MhFP7zrf2LM4lt8=";
  dontNpmBuild = true;

  nativeBuildInputs = [
    copyDesktopItems
  ];

  # npm install will error when electron tries to download its binary
  # we don't need it anyways since we wrap the program with our nixpkgs electron
  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  postPatch = ''
    # https://github.com/electron/electron/issues/31121
    substituteInPlace src/paths.js \
      --replace-fail "process.resourcesPath" "'$out/lib/node_modules/${pname}/assets'"
  '';

  postInstall = ''
    mkdir -p $out/share/icons
    ln -s $out/lib/node_modules/${pname}/build/icons/icon.png $out/share/icons/${pname}.png
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/lib/node_modules/${pname}/
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "google-chat-linux";
      exec = "google-chat-linux";
      icon = "google-chat-linux";
      desktopName = "Google Chat";
      comment = meta.description;
      categories = [
        "Network"
        "InstantMessaging"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Electron-base client for Google Hangouts Chat";
    homepage = "https://github.com/squalou/google-chat-linux";
    downloadPage = "https://github.com/squalou/google-chat-linux/releases";
    changelog = "https://github.com/squalou/google-chat-linux/releases/tag/${version}";
    license = lib.licenses.wtfpl;
    mainProgram = "google-chat-linux";
    maintainers = with lib.maintainers; [
      cterence
    ];
    platforms = lib.platforms.linux;
  };
}
