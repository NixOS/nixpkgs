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

<<<<<<< HEAD
let
  yarnLock = ./yarn.lock;
  offlineCache = fetchYarnDeps {
    inherit yarnLock;
    hash = "sha256-MRCrBvqDpPpwMg4A50RVKGp4GqRHNjNJzSpJz+14OG4=";
  };
in
stdenvNoCC.mkDerivation rec {
  pname = "Sharedown";
  version = "5.3.6-unstable-2025-12-06";
=======
stdenvNoCC.mkDerivation rec {
  pname = "Sharedown";
  version = "5.3.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "kylon";
    repo = "Sharedown";
<<<<<<< HEAD
    rev = "c39f0c5bbf694c2cdfce4ef0b4381342fb535ecc";
    hash = "sha256-PsfE7v9yEeGC8rUzhj/klhqtKKzxCV+thwLnQlgfDxI=";
=======
    tag = version;
    hash = "sha256-5t/71T/eBg4vkDZTj7mtCkXhS+AuiVhBmx0Zzrry5Lg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
        inherit
          pname
          version
          offlineCache
          yarnLock
          ;
=======
        inherit pname version;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
=======
        yarnLock = ./yarn.lock;

        offlineCache = fetchYarnDeps {
          inherit yarnLock;
          hash = "sha256-9Mdn18jJTXyAVQMGl9ImIEbzlkK6walPrgkGzupLPFQ=";
        };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  passthru = {
    inherit offlineCache;
    updateScript = ./update.sh;
  };
=======
  passthru.updateScript = ./update.sh;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Application to save your Sharepoint videos for offline usage";
    homepage = "https://github.com/kylon/Sharedown";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "Sharedown";
  };
}
