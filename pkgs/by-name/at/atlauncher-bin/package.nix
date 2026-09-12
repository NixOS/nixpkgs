{
  lib,
  fetchurl,
  jre,
  makeWrapper,
  stdenvNoCC,
  libglvnd,
  libpulseaudio,
  udev,
  libxxf86vm,
  libxcursor,
  libx11,
}:
let
  version = "3.4.41.2";
  runtimeLibraries = [
    libglvnd
    libpulseaudio
    udev
    libx11
    libxcursor
    libxxf86vm
  ];
  assets = fetchurl {
    url = "https://github.com/ATLauncher/ATLauncher/archive/refs/tags/v${version}.tar.gz";
    hash = "sha256-kQHZcoJLArYoQivZ/c9UTGoXIXXUwFnVK84leyZ7KHM=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "atlauncher-bin";
  inherit version;

  src = fetchurl {
    url = "https://github.com/ATLauncher/ATLauncher/releases/download/v${finalAttrs.version}/ATLauncher-${finalAttrs.version}.jar";
    hash = "sha256-XtOR4SV2qEy/g+GTac6A85dxatZxDksF+nKNqxvYlBQ=";
  };

  nativeBuildInputs = [ makeWrapper ];

  strictDeps = true;
  __structuredAttrs = true;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/java}
    cp $src $out/share/java/ATLauncher.jar

    makeWrapper ${lib.getExe jre} $out/bin/atlauncher \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibraries}" \
      --add-flags "-jar $out/share/java/ATLauncher.jar" \
      --add-flags "--working-dir \"\''${XDG_DATA_HOME:-\$HOME/.local/share}/ATLauncher\"" \
      --add-flags "--no-launcher-update"

    runHook postInstall
  '';

  postInstall = ''
    assetsDir="$TMPDIR/atlauncher-assets"
    mkdir -p "$assetsDir"
    tar xzf ${assets} -C "$assetsDir" --strip-components=1
    commonDir="$assetsDir/packaging/linux/_common"

    install -D -m444 "$commonDir/atlauncher.desktop" -t $out/share/applications
    install -D -m444 "$commonDir/atlauncher.metainfo.xml" -t $out/share/metainfo
    install -D -m444 "$commonDir/atlauncher.png" -t $out/share/icons/hicolor/128x128/apps
    install -D -m444 "$commonDir/atlauncher.svg" -t $out/share/icons/hicolor/scalable/apps
  '';

  meta = {
    changelog = "https://github.com/ATLauncher/ATLauncher/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Simple and easy to use Minecraft launcher which contains many different modpacks (official binary distribution)";
    downloadPage = "https://atlauncher.com/downloads";
    homepage = "https://atlauncher.com";
    license = lib.licenses.gpl3;
    mainProgram = "atlauncher";
    maintainers = with lib.maintainers; [
      getpsyched
      lPhiNix
    ];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})
