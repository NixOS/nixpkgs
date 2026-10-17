{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  electron,
  makeWrapper,
  python3,
  pkg-config,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
  libpulseaudio,
  libx11,
  libxtst,
  libxt,
  libxrandr,
}:

buildNpmPackage rec {
  pname = "haven-desktop";
  version = "1.7.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ancsemi";
    repo = "Haven-Desktop";
    tag = "v${version}";
    hash = "sha256-OzBYyyeiD/4hzSfWk5ZrriIFe8W+0kdX8lJefBC3jy8=";
  };

  npmDepsHash = "sha256-UTqIoMc0hkv6Ost+TLPWFKXZ1dcmev4ARYZBsoZlGvM=";
  npmFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = [
    makeWrapper
    python3
    pkg-config
    copyDesktopItems
  ];
  buildInputs = [ libpulseaudio ];

  buildPhase = ''
    runHook preBuild
    node node_modules/node-gyp/bin/node-gyp.js rebuild \
      --directory=native --nodedir=${electron.headers}
    npm prune --omit=dev --ignore-scripts
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/haven-desktop
    cp -r . $out/share/haven-desktop/app

    makeWrapper ${lib.getExe electron} $out/bin/haven-desktop \
      --add-flags $out/share/haven-desktop/app \
      --add-flags "--ozone-platform-hint=auto" \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libx11
          libxtst
          libxt
          libxrandr
        ]
      }

    install -Dm444 assets/icon.png $out/share/icons/hicolor/512x512/apps/haven-desktop.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "haven-desktop";
      desktopName = "Haven";
      exec = "haven-desktop %U";
      icon = "haven-desktop";
      categories = [
        "Network"
        "Chat"
      ];
    })
  ];
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Desktop client for the Haven private chat server";
    homepage = "https://haven-app.com/";
    license = lib.licenses.agpl3Only;
    mainProgram = "haven-desktop";
    maintainers = with lib.maintainers; [ Simpaqt ];
    platforms = lib.platforms.linux;
  };
}
