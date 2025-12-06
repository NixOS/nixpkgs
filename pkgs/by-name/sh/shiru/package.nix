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
}:
let
  electron = electron_39;
  pname = "shiru";
  version = "6.4.1";

  src = fetchFromGitHub {
    owner = "RockinChaos";
    repo = "shiru";
    tag = "v${version}";
    hash = "sha256-aYr5nCGEkYE27ZjODqltsSR7kY9YBwnqbt4qcRwt8TE=";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  patches = [
    # electron-shutdown-handler is only used on Windows and tries to download
    # files during build
    ./0001-Remove-Windows-specific-dep.patch
  ];

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
    python3
    makeBinaryWrapper
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit pname version src;
    prePnpmInstall = ''
      cd electron
    '';
    fetcherVersion = 2;
    hash = "sha256-YINaWE5wB6la31XXuhJlmQhjaNea3dL908e3ybctknY=";
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

  meta = with lib; {
    description = "Stream your personal media library in real-time";
    homepage = "https://github.com/RockinChaos/Shiru";
    changelog = "https://github.com/RockinChaos/Shiru/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      naomieow
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "shiru";
  };
}
