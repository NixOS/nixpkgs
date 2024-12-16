{
  lib,
  stdenvNoCC,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  ffmpeg,
  alsa-lib,
  SDL2,
  lttng-ust,
  numactl,
  libglvnd,
  xorg,
  udev,
  vulkan-loader,
  nativeWayland ? false,
}:

buildDotnetModule rec {
  pname = "osu-lazer";
  version = "2024.1208.0";

  src = fetchFromGitHub {
    owner = "ppy";
    repo = "osu";
    tag = version;
    hash = "sha256-cMPVtzoTxIUVZNNAqF+H0873ZsXGluFEXwNDp7zOq8c=";
  };

  projectFile = "osu.Desktop/osu.Desktop.csproj";
  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  runtimeDeps = [
    ffmpeg
    alsa-lib
    SDL2
    lttng-ust
    numactl

    # needed to avoid:
    # Failed to create SDL window. SDL Error: Could not initialize OpenGL / GLES library
    libglvnd

    # needed for the window to actually appear
    xorg.libXi

    # needed to avoid in runtime.log:
    # [verbose]: SDL error log [debug]: Failed loading udev_device_get_action: /nix/store/*-osu-lazer-*/lib/osu-lazer/runtimes/linux-x64/native/libSDL2.so: undefined symbol: _udev_device_get_action
    # [verbose]: SDL error log [debug]: Failed loading libudev.so.1: libudev.so.1: cannot open shared object file: No such file or directory
    udev

    # needed for vulkan renderer, can fall back to opengl if omitted
    vulkan-loader
  ];

  executables = [ "osu!" ];

  fixupPhase = ''
    runHook preFixup

    wrapProgram $out/bin/osu! \
      ${lib.optionalString nativeWayland "--set SDL_VIDEODRIVER wayland"} \
      --set OSU_EXTERNAL_UPDATE_PROVIDER 1

    for i in 16 32 48 64 96 128 256 512 1024; do
      install -D ./assets/lazer.png $out/share/icons/hicolor/''${i}x$i/apps/osu.png
    done

    ln -sft $out/lib/${pname} ${SDL2}/lib/libSDL2${stdenvNoCC.hostPlatform.extensions.sharedLibrary}
    cp -f ${./osu.runtimeconfig.json} "$out/lib/${pname}/osu!.runtimeconfig.json"

    runHook postFixup
  '';

  desktopItems = [
    (makeDesktopItem {
      desktopName = "osu!";
      name = "osu";
      exec = "osu!";
      icon = "osu";
      comment = "Rhythm is just a *click* away (no score submission or multiplayer, see osu-lazer-bin)";
      type = "Application";
      categories = [ "Game" ];
    })
  ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Rhythm is just a *click* away (no score submission or multiplayer, see osu-lazer-bin)";
    homepage = "https://osu.ppy.sh";
    license = with lib.licenses; [
      mit
      cc-by-nc-40
      unfreeRedistributable # osu-framework contains libbass.so in repository
    ];
    maintainers = with lib.maintainers; [
      gepbird
      thiagokokada
      Guanran928
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "osu!";
  };
}
