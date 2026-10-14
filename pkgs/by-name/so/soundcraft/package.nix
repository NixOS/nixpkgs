{
  lib,
  fetchFromGitHub,
  rustPlatform,
  rustc,
  pkg-config,
  copyDesktopItems,
  makeDesktopItem,
  patchelf,
  alsa-lib,
  libx11,
  libxcb,
  libGL,
  libxkbcommon,
  nix-update-script,
  wayland,
  libxcursor,
  libxi,
  vulkan-loader,
  dbus,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "soundcraft";
  version = "0.6.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "soundcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VC9DzuzajyGr82cEKPpgc0rezU9lJdaGNKd+foazRU8=";
  };

  cargoHash = "sha256-qaY9GeH26onJoYfJC1bCBu3q3Xmc5JV2SsK8xSqbLzE=";

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
  ];

  buildInputs = [
    alsa-lib
    libx11
    libxcb
    libGL
    libxkbcommon
    wayland
    # dlopened at runtime by winit/x11-dl, x11rb (dl-libxcb), xkbcommon-dl, wgpu and
    # g-desktop-portal; the fork's libx11 also ships libX11-xcb.so.1 in the same dir.
    libxcursor
    libxi
    vulkan-loader
    dbus
  ];

  # The clap-host/engine integration tests spawn a nested `cargo build` for an out-of-workspace
  # fixture cdylib and expect its artefacts at target/debug/..., which does not hold up under
  # the sandboxed, release-profile nix check environment.
  doCheck = false;

  cargoBuildFlags = [
    "-p"
    "soundcraft"
    "-p"
    "soundcraft-cli"
  ];

  postInstall = ''
    # Install under the hicolor theme and publish an index.theme; without one, GTK/KDE icon
    # lookups cannot see the icons (upstream ships no index.theme).
    install -d $out/share/icons
    cp -r assets/app-icon/hicolor $out/share/icons
  '';

  postFixup = ''
    patchelf --set-rpath "${
      lib.makeLibraryPath [
        alsa-lib
        libx11
        libxcb
        libGL
        libxkbcommon
        wayland
        libxcursor
        libxi
        vulkan-loader
        dbus
      ]
    }" \
      $out/bin/soundcraft
  '';

  desktopItem = makeDesktopItem {
    name = "soundcraft";
    desktopName = "SoundCraft";
    genericName = "Digital Audio Workstation";
    icon = "ai.storyteller.soundcraft";
    tryExec = "soundcraft";
    exec = "soundcraft";
    comment = "Record, edit and mix audio and MIDI";
    mimeTypes = [
      "application/x-soundcraft-session"
      "audio/x-wav"
      "audio/wav"
      "audio/vnd.wave"
      "audio/x-aiff"
      "audio/aiff"
      "audio/flac"
      "audio/x-flac"
      "audio/mpeg"
      "audio/midi"
      "audio/x-midi"
    ];
    categories = [
      "AudioVideo"
      "Audio"
      "Midi"
      "Mixer"
      "Sequencer"
      "Recorder"
    ];
    startupNotify = true;
    startupWMClass = "ai.storyteller.soundcraft";
    keywords = [
      "daw"
      "audio"
      "mixer"
      "recording"
      "multitrack"
      "midi"
      "editor"
      "music"
    ];
  };

  desktopItems = [ finalAttrs.desktopItem ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SoundCraft desktop app";
    homepage = "https://github.com/storytold/soundcraft";
    changelog = "https://github.com/storytold/soundcraft/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.OR [
      lib.licenses.asl20
      lib.licenses.mit
    ];
    mainProgram = "soundcraft";
    maintainers = with lib.maintainers; [
      gaelj
    ];
    platforms = rustc.meta.platforms;
  };
})
