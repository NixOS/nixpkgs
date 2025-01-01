{
  buildNpmPackage,
  copyDesktopItems,
  electron,
  fetchFromGitHub,
  lib,
  makeDesktopItem,
}:

buildNpmPackage rec {
  pname = "google-chat-linux";
  version = "5.29.23-1";

  src = fetchFromGitHub {
    owner = "squalou";
    repo = "google-chat-linux";
    rev = "refs/tags/${version}";
    hash = "sha256-JBjxZUs0HUgAkJJBYhNv2SHjpBtAcP09Ah4ATPwpZsQ=";
  };

  npmDepsHash = "sha256-7lKWbXyDpYh1sP9LAV/oA7rfpckSbIucwKT21vBrJ3Y=";
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
