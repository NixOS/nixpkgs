{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  electron,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
  makeWrapper,
  kopia,
}:
let
  version = "0.21.1";
  src = fetchFromGitHub {
    owner = "kopia";
    repo = "kopia";
    tag = "v${version}";
    hash = "sha256-0i8bKah3a7MrgzATysgFCsmDZxK9qH+4hmBMW+GR9/4=";
  };
in
buildNpmPackage {
  pname = "kopia-ui";
  inherit version src;

  sourceRoot = "${src.name}/app";

  npmDepsHash = "sha256-IoPR3es5rHVOxITYCG5I3ETB/KKh5Ku8ftyR9uQH//8=";
  makeCacheWritable = true;

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  patches = [ ./fix-paths.patch ];

  postPatch = ''
    substituteInPlace public/utils.js --replace-fail KOPIA ${lib.getExe kopia}
  '';

  buildPhase = ''
    runHook preBuild
    cp -r ${electron.dist} electron-dist
    chmod -R u+w ..
    npm exec electron-builder -- \
      --dir \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version} \
      -c.extraMetadata.version=v${version}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/kopia
    cp -r ../dist/kopia-ui/*-unpacked/{locales,resources{,.pak}} $out/share/kopia
    install -Dm644 $src/icons/kopia.svg $out/share/icons/hicolor/scalable/apps/kopia.svg
    makeWrapper ${lib.getExe electron} $out/bin/kopia-ui \
      --prefix PATH : ${lib.makeBinPath [ kopia ]} \
      --add-flags $out/share/kopia/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --inherit-argv0
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "kopia-ui";
      type = "Application";
      desktopName = "KopiaUI";
      comment = "Fast and secure open source backup.";
      icon = "kopia";
      exec = "kopia-ui";
      categories = [ "Utility" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross-platform backup tool with fast, incremental backups, client-side end-to-end encryption, compression and data deduplication";
    mainProgram = "kopia-ui";
    homepage = "https://kopia.io";
    downloadPage = "https://github.com/kopia/kopia";
    changelog = "https://github.com/kopia/kopia/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ blenderfreaky ];
    platforms = lib.platforms.linux;
  };
}
