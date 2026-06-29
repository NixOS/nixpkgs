{
  lib,
  stdenv,
  fetchFromGitHub,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
  alsa-lib,
  godot3-export-templates,
  godot3-headless,
  libGL,
  libX11,
  libXcursor,
  libXext,
  libXi,
  libXinerama,
  libXrandr,
  libXrender,
  SDL2,
  udev,
}:
let
  tag = "oct31-2024";
  version = "0-${tag}";
in
stdenv.mkDerivation (finalAttrs: {
  inherit version;
  pname = "rhythia";

  src = fetchFromGitHub {
    inherit tag;
    owner = "David20122";
    repo = "sound-space-plus";
    hash = "sha256-HI4WWJbNY0RyG3ORP/jY3YaXTBSODHq1ZijxYmeoNkY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    godot3-headless
  ];

  buildInputs = [
    SDL2
    libGL
    libX11
    libXcursor
    libXext
    libXi
    libXinerama
    libXrandr
    libXrender
  ];

  runtimeDependencies = [
    alsa-lib
    udev
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "rhythia";
      desktopName = "Rhythia";
      genericName = finalAttrs.meta.description;
      comment = finalAttrs.meta.description;
      icon = "rhythia";
      exec = "rhythia";
      categories = [ "Game" ];
      keywords = [
        "sound"
        "space"
        "plus"
        "rhythm"
      ];
      singleMainWindow = true;
      terminal = false;
      prefersNonDefaultGPU = true;
    })
  ];

  buildPhase = ''
    runHook preBuild

    export HOME=$TMPDIR

    mkdir -p $HOME/.local/share/godot
    ln -s ${godot3-export-templates}/share/godot/templates $HOME/.local/share/godot

    cp ${./export_presets.cfg} ./export_presets.cfg

    mkdir -p addons/discord_game_sdk/bin/x86_64/
    cp addons/discord_game_sdk/*.so addons/discord_game_sdk/bin/x86_64/

    mkdir -p $out/share/rhythia
    godot3-headless --export "Linux/X11" $out/share/rhythia/rhythia

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    ln -s $out/share/rhythia/rhythia $out/bin/

    install -Dm644 assets/images/branding/icon.png $out/share/pixmaps/rhythia.png

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rhythm-based aim game";
    homepage = "https://www.rhythia/";
    license = with lib.licenses; [
      mit # The game itself
      unfree # Discord Game SDK
    ];
    maintainers = with lib.maintainers; [ ungeskriptet ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "rhythia";
  };
})
