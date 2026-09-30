{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  makeDesktopItem,
  nix-update-script,

  copyDesktopItems,
  makeWrapper,

  ffmpeg,
  hunspell,
  libGL,
  libxcursor,
  mpv,
  tesseract4,
}:

buildDotnetModule (finalAttrs: {
  pname = "subtitleedit";
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "SubtitleEdit";
    repo = "subtitleedit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OuCaHSk/wMx3kwQY5J9S2dQcy87KfvG+nuKGCJZpiCk=";
  };

  projectFile = "src/ui/UI.csproj";
  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;
  nugetDeps = ./deps.json;

  executables = [ "SubtitleEdit" ];

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  runtimeDeps = [
    ffmpeg
    hunspell
    mpv
    tesseract4
    libGL
    libxcursor
  ];

  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      desktopName = "Subtitle Edit";
      exec = "SubtitleEdit";
      icon = "subtitleedit";
      comment = "Subtitle editor";
      categories = [ "AudioVideo" ];
    })
  ];

  patchPhase = ''
    # fix video player because the lib directory paths they use to find mpv are hard-coded
    substituteInPlace src/ui/Logic/VideoPlayers/LibMpvDynamic/LibMpvDynamicPlayer.cs \
      --replace-fail '"/usr/local/lib",' '"${mpv}/lib",'
  '';

  preFixup = ''
    install -D src/libse/Icon.png $out/share/icons/hicolor/256x256/apps/subtitleedit.png

    wrapProgram $out/bin/SubtitleEdit \
      --prefix PATH : ${
        lib.makeBinPath [
          ffmpeg
          hunspell
          tesseract4
        ]
      }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Free, open-source editor for video subtitles";
    homepage = "https://subtitleedit.github.io/subtitleedit/";
    license = lib.licenses.mit;
    platforms = finalAttrs.dotnet-runtime.meta.platforms;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ fqidz ];
    mainProgram = "SubtitleEdit";
  };
})
