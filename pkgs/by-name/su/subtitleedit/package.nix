{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  makeDesktopItem,
  nix-update-script,

  copyDesktopItems,
  icoutils,
  makeWrapper,

  ffmpeg,
  hunspell,
  libGL,
  libx11,
  mpv,
  tesseract4,
}:

buildDotnetModule (finalAttrs: {
  pname = "subtitleedit";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "SubtitleEdit";
    repo = "subtitleedit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3WwRXD1JhZisJ/1sOF91PvrklfjCiI2Ena4i8AdLcm0=";
  };

  projectFile = "src/ui/UI.csproj";
  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;
  nugetDeps = ./deps.json;

  executables = [ "SubtitleEdit" ];

  nativeBuildInputs = [
    copyDesktopItems
    icoutils
    makeWrapper
  ];

  runtimeDeps = [
    libGL
    libx11
    hunspell
    mpv
    tesseract4
  ];

  runtimePathDeps = [
    ffmpeg
    hunspell
    tesseract4
  ];

  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      desktopName = "Subtitle Edit";
      exec = "subtitleedit";
      icon = "subtitleedit";
      comment = finalAttrs.meta.description;
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
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = [ ];
  };
})
