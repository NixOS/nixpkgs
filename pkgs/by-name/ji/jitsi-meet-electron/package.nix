{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  xcbuild,
  libpng,
  libX11,
  libXi,
  libXtst,
  zlib,
  electron_39,
}:

let
  electron = electron_39;
in
buildNpmPackage rec {
  pname = "jitsi-meet-electron";
  version = "2025.10.0";

  src = fetchFromGitHub {
    owner = "jitsi";
    repo = "jitsi-meet-electron";
    tag = "v${version}";
    hash = "sha256-GKsTM/dDwt8JnV0TKe3kc9bcnPatJjX60/Ou/4aG4VA=";
  };

  patches = [
    ./bump-node-abi.patch # allow detecting the electron_39 ABI
  ];

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    copyDesktopItems
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    xcbuild
  ];

  # robotjs node-gyp dependencies
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libpng
    libX11
    libXi
    libXtst
    zlib
  ];

  npmDepsHash = "sha256-SjizHcD//yIwquJViiS6cIXLwhWeTrm5EJHMRDwbb6U=";

  makeCacheWritable = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  env.NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration";

  preBuild = ''
    # remove some prebuilt binaries
    find node_modules -type d -name prebuilds -exec rm -r {} +

    # don't force both darwin architectures together
    substituteInPlace node_modules/@jitsi/robotjs/binding.gyp \
      --replace-fail "-arch x86_64" "" \
      --replace-fail "-arch arm64" ""
  '';

  postBuild = ''
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    export npm_config_nodedir=${electron.headers}

    # npmRebuild is needed because robotjs won't be built on darwin otherwise
    # asarUnpack makes sure to unwrap binaries so that nix can see the RPATH
    npm exec electron-builder -- \
      --dir \
      -c.mac.identity=null \
      -c.npmRebuild=true \
      -c.asarUnpack="**/*.node" \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version}
  '';

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/share/jitsi-meet-electron
    cp -r dist/*-unpacked/{locales,resources{,.pak}} $out/share/jitsi-meet-electron

    makeWrapper ${lib.getExe electron} $out/bin/jitsi-meet-electron \
      --add-flags $out/share/jitsi-meet-electron/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

    install -Dm644 resources/icons/512x512.png $out/share/icons/hicolor/512x512/apps/jitsi-meet-electron.png
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r dist/mac*/"Jitsi Meet.app" $out/Applications
    makeWrapper "$out/Applications/Jitsi Meet.app/Contents/MacOS/Jitsi Meet" $out/bin/jitsi-meet-electron
  ''
  + ''
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

  meta = {
    changelog = "https://github.com/jitsi/jitsi-meet-electron/releases/tag/${src.tag}";
    description = "Jitsi Meet desktop application powered by Electron";
    homepage = "https://github.com/jitsi/jitsi-meet-electron";
    license = lib.licenses.asl20;
    mainProgram = "jitsi-meet-electron";
    maintainers = [ lib.maintainers.tomasajt ];
    teams = [ lib.teams.jitsi ];
    inherit (electron.meta) platforms;
  };
}
