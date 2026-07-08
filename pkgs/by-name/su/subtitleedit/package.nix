{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  makeDesktopItem,
  nix-update-script,

  copyDesktopItems,
  makeWrapper,
  ffmpeg,
  hunspell,
  mpv,
  tesseract4,
  dotnetCorePackages,
  libxcursor,
  libGL,

}:

buildDotnetModule (finalAttrs: {
  pname = "subtitleedit";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "SubtitleEdit";
    repo = "subtitleedit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-07dEThNWkAvxFoojDVfGGHqfL/EnM0xqjfjaKhPq6nU=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;
  nugetDeps = ./deps.json;
  runtimeDeps = [
    hunspell
    mpv
    tesseract4
    libGL
    libxcursor
  ];

  projectFile = "src/ui/UI.csproj";
  enableParallelBuilding = false;
  executables = [ "SubtitleEdit" ];

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

  desktopItems = [
    (makeDesktopItem {
      name = "subtitleedit";
      desktopName = "Subtitle Edit";
      exec = "subtitleedit";
      icon = "subtitleedit";
      comment = "Subtitle editor";
      categories = [ "AudioVideo" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Subtitle editor";
    longDescription = ''
      With Subtitle Edit you can easily adjust a subtitle if it is out of sync with
      the video in several different ways. You can also use it for making
      new subtitles from scratch (using the time-line /waveform/spectrogram)
      or for translating subtitles.
    '';
    homepage = "https://nikse.dk/subtitleedit";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = [ ];
  };
})
