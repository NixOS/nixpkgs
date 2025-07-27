{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "sonicradio";

  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "dancnb";
    repo = "sonicradio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lkozjRq5sRLZoGrm0hVk465NjAShwIwcN1uEkIxiaOE=";
  };

  vendorHash = "sha256-qjaOUXS8bolwlEJXk8xr8wVf7hru1apjTsr2U6tFb0U=";

  nativeBuildInputs = [
    copyDesktopItems
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "SonicRadio";
      exec = "sonicradio";
      terminal = true;
      comment = finalAttrs.meta.description;
      desktopName = "Sonic Radio";
      genericName = "Terminal Radio Player";
      categories = [
        "AudioVideo"
        "Audio"
        "ConsoleOnly"
      ];
      keywords = [
        "Radio"
        "TUI"
        "Internet"
        "Streaming"
      ];
    })
  ];

  # Tests require music player binaries and networking
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "TUI radio player making use of Radio Browser API and Bubbletea";
    homepage = "https://github.com/dancnb/sonicradio";
    changelog = "https://github.com/dancnb/sonicradio/releases/tag/v${finalAttrs.version}";
    mainProgram = "sonicradio";
    longDescription = ''
      A stylish TUI radio player making use of Radio Browser API and Bubbletea.
      Sonicplayer requires mpv, ffplay (ffmpeg), vlc, mplayer or mpd installed.
    '';
    license = lib.licenses.mit;
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    maintainers = with lib.maintainers; [ alexandrutocar ];
  };
})
