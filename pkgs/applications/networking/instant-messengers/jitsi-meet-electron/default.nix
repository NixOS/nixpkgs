{ lib
, buildNpmPackage
, fetchFromGitHub
, copyDesktopItems
, makeDesktopItem
, makeWrapper
, libpng
, libX11
, libXi
, libXtst
, zlib
, electron
, pipewire
}:

buildNpmPackage rec {
  pname = "jitsi-meet-electron";
  version = "2023.11.3";

  src = fetchFromGitHub {
    owner = "jitsi";
    repo = "jitsi-meet-electron";
    rev = "v${version}";
    hash = "sha256-gE5CP0l3SrAHGNS6Hr5/MefTtE86JTmc85CwOmylEpg=";
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

  npmDepsHash = "sha256-JZVJcKzG4X7YIUvIRWZsDQnHx+dNqCj6kFm8mZaSH2k=";

  makeCacheWritable = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  postPatch = ''
    substituteInPlace main.js \
        --replace "require('electron-is-dev')" "false"
  '';

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
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ pipewire ]} \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
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
      categories = [ "VideoConference" "AudioVideo" "Audio" "Video" "Network" ];
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
