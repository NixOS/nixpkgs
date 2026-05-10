{
  lib,
  stdenv,
  pnpm,
  nodejs,
  fetchFromGitHub,
  python3,
  electron_39,
  makeDesktopItem,
  makeBinaryWrapper,
  copyDesktopItems,
  fetchPnpmDeps,
  pnpmConfigHook,
  nix-update-script,
}:
let
  electron = electron_39;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "shiru";
  version = "6.6.0";

  src = fetchFromGitHub {
    owner = "RockinChaos";
    repo = "shiru";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LccI6Z4hhkmzWHt0CKum9giJMVGm3qM0ZKNvChUCYQ4=";
  };

  patches = [
    # electron-shutdown-handler is only used on Windows and tries to download
    # files during build
    ./0001-Remove-Windows-specific-dep.patch
  ];

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
    python3
    makeBinaryWrapper
    copyDesktopItems
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    prePnpmInstall = ''
      cd electron
    '';
    fetcherVersion = 3;
    hash = "sha256-bTo6sEQuUghwm2I99WB7+akL4AOZ1ZN2ovaLWrd5MMg=";
  };

  buildPhase = ''
    runHook preBuild

    cd electron

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    npm run web:build

    ./node_modules/.bin/electron-builder --dir \
      --c.electronDist=electron-dist \
      --c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/lib/shiru"
    cp -r dist/*-unpacked/{locales,resources{,.pak}} "$out/share/lib/shiru"

    install -Dm644 buildResources/icon.png "$out/share/icons/hicolor/512x512/apps/shiru.png"

    makeWrapper '${electron}/bin/electron' "$out/bin/shiru" \
      --add-flags "$out/share/lib/shiru/resources/app.asar" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}" \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "shiru";
      exec = "shiru %U";
      icon = "shiru";
      desktopName = "Shiru";
      genericName = "Personal Media Library";
      comment = "Manage your personal media library, organize your collection, and stream your content in real time, no waiting required!";
      categories = [
        "Video"
        "AudioVideo"
      ];
      keywords = [ "Anime" ];
      mimeTypes = [ "x-scheme-handler/shiru" ];
    })
  ];

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Stream your personal media library in real-time";
    homepage = "https://github.com/RockinChaos/Shiru";
    changelog = "https://github.com/RockinChaos/Shiru/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      naomieow
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "shiru";
  };
})
