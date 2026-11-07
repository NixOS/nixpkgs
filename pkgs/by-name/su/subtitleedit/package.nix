{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  nix-update-script,

  makeWrapper,

  ffmpeg,
  hunspell,
  libGL,
  libxcursor,
  mpv,
  libvlc,
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

  nativeBuildInputs = [ makeWrapper ];

  runtimeDeps = [
    ffmpeg
    hunspell
    mpv
    libvlc
    tesseract4
    libGL
    libxcursor
  ];

  patchPhase = ''
    # fix video player because the lib directory paths they use to find mpv are hard-coded
    substituteInPlace src/ui/Logic/VideoPlayers/LibMpvDynamic/LibMpvDynamicPlayer.cs \
      --replace-fail '"/usr/local/lib",' '"${mpv}/lib",'

    substituteInPlace src/ui/Logic/VideoPlayers/LibVlcDynamic/LibVlcDynamicPlayer.cs \
      --replace-fail '"/usr/local/lib",' '"${libvlc}/lib",'
  '';

  preFixup = ''
    install -Dm644 installer/flatpak/dk.nikse.subtitleedit.desktop $out/share/applications/dk.nikse.subtitleedit.desktop
    install -Dm644 installer/flatpak/dk.nikse.subtitleedit.metainfo.xml $out/share/metainfo/dk.nikse.subtitleedit.metainfo.xml
    install -Dm644 src/ui/Assets/SE.png $out/share/icons/hicolor/256x256/apps/dk.nikse.subtitleedit.png
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
