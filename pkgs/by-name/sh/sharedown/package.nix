{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  ffmpeg,
  yt-dlp,
  libsecret,
  python3,
  pkg-config,
  nodejs,
  electron,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  yarn2nix-moretea,
  fetchYarnDeps,
  chromium,
}:

stdenvNoCC.mkDerivation rec {
  pname = "Sharedown";
  version = "5.3.6";

  src = fetchFromGitHub {
    owner = "kylon";
    repo = "Sharedown";
    tag = version;
    hash = "sha256-5t/71T/eBg4vkDZTj7mtCkXhS+AuiVhBmx0Zzrry5Lg=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "Sharedown";
      exec = "Sharedown";
      icon = "Sharedown";
      comment = "An Application to save your Sharepoint videos for offline usage.";
      desktopName = "Sharedown";
      categories = [
        "Network"
        "Archiving"
      ];
    })
  ];

  dontBuild = true;

  installPhase =
    let
      binPath = lib.makeBinPath [
        ffmpeg
        yt-dlp
      ];

      modules = yarn2nix-moretea.mkYarnModules rec {
        name = "Sharedown-modules-${version}";
        inherit pname version;

        yarnFlags = [ "--production" ];

        pkgConfig = {
          keytar = {
            nativeBuildInputs = [
              python3
              pkg-config
            ];
            buildInputs = [
              libsecret
            ];
            postInstall = ''
              yarn --offline run build
              # Remove unnecessary store path references.
              rm build/config.gypi
            '';
          };
        };

        # needed for node-gyp, copied from https://nixos.org/manual/nixpkgs/unstable/#javascript-yarn2nix-pitfalls
        # permalink: https://github.com/NixOS/nixpkgs/blob/d176767c02cb2a048e766215078c3d231e666091/doc/languages-frameworks/javascript.section.md#pitfalls-javascript-yarn2nix-pitfalls
        preBuild = ''
          mkdir -p $HOME/.node-gyp/${nodejs.version}
          echo 9 > $HOME/.node-gyp/${nodejs.version}/installVersion
          ln -sfv ${nodejs}/include $HOME/.node-gyp/${nodejs.version}
          export npm_config_nodedir=${nodejs}
        '';

        postBuild = ''
          rm $out/node_modules/sharedown
        '';

        packageJSON = "${src}/package.json";
        yarnLock = ./yarn.lock;

        offlineCache = fetchYarnDeps {
          inherit yarnLock;
          hash = "sha256-9Mdn18jJTXyAVQMGl9ImIEbzlkK6walPrgkGzupLPFQ=";
        };
      };
    in
    ''
      runHook preInstall

      mkdir -p "$out/bin" "$out/share/Sharedown" "$out/share/applications" "$out/share/icons/hicolor/512x512/apps"

      # Electron app
      cp -r *.js *.json sharedownlogo.png sharedown "${modules}/node_modules" "$out/share/Sharedown"

      # Desktop Launcher
      cp build/icon.png "$out/share/icons/hicolor/512x512/apps/Sharedown.png"

      # Install electron wrapper script
      makeWrapper "${electron}/bin/electron" "$out/bin/Sharedown" \
        --add-flags "$out/share/Sharedown" \
        --prefix PATH : "${binPath}" \
        --set PUPPETEER_EXECUTABLE_PATH "${chromium}/bin/chromium"

      runHook postInstall
    '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Application to save your Sharepoint videos for offline usage";
    homepage = "https://github.com/kylon/Sharedown";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "Sharedown";
  };
}
