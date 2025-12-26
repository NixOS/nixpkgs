{
  lib,
  stdenvNoCC,
  fetchzip,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  wrapGAppsHook3,
  alsa-lib,
  dotnetCorePackages,
  gtk3,
  libGL,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "grooveauthor";
  version = "1.1.3";

  src = fetchzip {
    url = "https://github.com/PerryAsleep/GrooveAuthor/releases/download/v${finalAttrs.version}/GrooveAuthor-v${finalAttrs.version}-linux-x64.tar.gz";
    hash = "sha256-XuELs7Sj/M32ros5clKxKuVo/CdCja39Lwc+zsFGvFU=";
    stripRoot = false;
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    wrapGAppsHook3
  ];

  runtimeDependencies = [ gtk3 ];

  desktopItems = [
    (makeDesktopItem {
      desktopName = "GrooveAuthor";
      name = finalAttrs.pname;
      genericName = "Editor for StepMania";
      icon = "GrooveAuthor";
      exec = "GrooveAuthor";
      categories = [
        "AudioVideo"
        "AudioVideoEditing"
      ];
      keywords = [
        "GrooveAuthor"
        "StepMania"
        "ITG"
        "ITGmania"
        "DDR"
        "PIU"
        "Pump It Up"
        "Dance"
        "StepF2"
        "StepP1"
      ];
      prefersNonDefaultGPU = true;
      singleMainWindow = true;
      terminal = false;
    })
  ];

  installPhase = ''
    runHook preInstall
    install -Dm444 grooveauthor/Icon.svg $out/share/icons/hicolor/scalable/apps/GrooveAuthor.svg
    mv grooveauthor $out/bin
    rm $out/bin/{GrooveAuthor.desktop,Icon.svg}
    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set DOTNET_ROOT ${dotnetCorePackages.runtime_8_0}/share/dotnet
      --suffix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          alsa-lib
          libGL
        ]
      }"
    )
  '';

  meta = {
    description = "GrooveAuthor is an editor for authoring StepMania charts";
    homepage = "https://github.com/PerryAsleep/GrooveAuthor";
    license = with lib.licenses; [
      mit
      mspl
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "GrooveAuthor";
  };
})
