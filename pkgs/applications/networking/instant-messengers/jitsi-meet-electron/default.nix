{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  libpng,
  libX11,
  libXi,
  libXtst,
  zlib,
  electron,
}:

buildNpmPackage rec {
  pname = "jitsi-meet-electron";
  version = "2024.3.0";

  src = fetchFromGitHub {
    owner = "jitsi";
    repo = "jitsi-meet-electron";
    rev = "v${version}";
    hash = "sha256-BGN+t9Caw5n/NN1E5Oi/ruMLjoVh0jUlpzYR6vodHbw=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  # robotjs node-gyp dependencies
  buildInputs = [
    libpng
    libX11
    libXi
    libXtst
    zlib
  ];

  npmDepsHash = "sha256-KanG8y+tYzswCCXjSkOlk+p9XKaouP2Z7IhsD5bDtRk=";

  makeCacheWritable = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  preBuild = ''
    # remove some prebuilt binaries
    find node_modules -type d -name prebuilds -exec rm -r {} +
  '';

  postBuild = ''
    # generate .asar file
    # asarUnpack makes sure to unwrap binaries so that nix can see the RPATH
    npm exec electron-builder -- \
        --dir \
        -c.asarUnpack="**/*.node" \
        -c.electronDist=${electron}/libexec/electron \
        -c.electronVersion=${electron.version}
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/jitsi-meet-electron
    cp -r dist/*-unpacked/{locales,resources{,.pak}} $out/share/jitsi-meet-electron

    makeWrapper ${lib.getExe electron} $out/bin/jitsi-meet-electron \
        --add-flags $out/share/jitsi-meet-electron/resources/app.asar \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
        --set-default ELECTRON_IS_DEV 0 \
        --inherit-argv0

    install -Dm644 resources/icons/512x512.png $out/share/icons/hicolor/512x512/apps/jitsi-meet-electron.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "jitsi-meet-electron";
      exec = "jitsi-meet-electron %U";
      icon = "jitsi-meet-electron";
      desktopName = "Jitsi Meet";
      comment = meta.description;
      categories = [
        "VideoConference"
        "AudioVideo"
        "Audio"
        "Video"
        "Network"
      ];
      mimeTypes = [ "x-scheme-handler/jitsi-meet" ];
      terminal = false;
    })
  ];

  meta = with lib; {
    changelog = "https://github.com/jitsi/jitsi-meet-electron/releases/tag/${src.rev}";
    description = "Jitsi Meet desktop application powered by Electron";
    homepage = "https://github.com/jitsi/jitsi-meet-electron";
    license = licenses.asl20;
    mainProgram = "jitsi-meet-electron";
    maintainers = teams.jitsi.members ++ [ maintainers.tomasajt ];
    inherit (electron.meta) platforms;
  };
}
