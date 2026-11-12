{
  lib,
  stdenv,
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
  xcbuild,
  rcodesign,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "soundcraft";
  version = "0.12.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "soundcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KiNJ/iVR8QHW6z6BBTS3n1TCGsFsWkY2N+OMyywjND0=";
  };

  cargoHash = "sha256-JHI2cqHfGYMn9e8QmRDt16sKc5mdIbjo/ajSnGMGpLA=";

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      pkg-config
      copyDesktopItems
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      xcbuild
      rcodesign
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

  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      # Install under the hicolor theme and publish an index.theme; without one, GTK/KDE icon
      # lookups cannot see the icons (upstream ships no index.theme).
      install -d $out/share/icons
      cp -r assets/app-icon/hicolor $out/share/icons
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      APP="$out/Applications/SoundCraft.app"

      mkdir -p $APP/Contents/{MacOS,Resources}

      ln -s $out/bin/soundcraft $APP/Contents/MacOS/SoundCraft
      ln -s $out/bin/soundcraft-cli $APP/Contents/MacOS/soundcraft-cli

      cp $NIX_BUILD_TOP/source/assets/app-icon/soundcraft.icns $APP/Contents/Resources/SoundCraft.icns
      cp $NIX_BUILD_TOP/source/NOTICE $NIX_BUILD_TOP/source/ATTRIBUTION.md $APP/Contents/Resources/

      sed -e "s/@VERSION@/${finalAttrs.version}/g" -e "s/@SHORT_VERSION@/${finalAttrs.version}/g" \
        -e "s/@BUILD_SHA@/unknown}/g" \
        "$NIX_BUILD_TOP/source/packaging/macos/Info.plist.in" >"$APP/Contents/Info.plist"
      plutil -lint "$APP/Contents/Info.plist"

      printf 'APPL????' >"$APP/Contents/PkgInfo"
      rcodesign sign \
        --code-signature-flags runtime \
        --entitlements-xml-file "$NIX_BUILD_TOP/source/packaging/macos/entitlements.plist" \
        "$APP/Contents/MacOS/SoundCraft"
      rcodesign sign \
        --code-signature-flags runtime \
        --entitlements-xml-file "$NIX_BUILD_TOP/source/packaging/macos/entitlements.plist" \
        "$APP"
    '';

  postFixup =
    # dlopened at runtime by winit/x11-dl, x11rb (dl-libxcb), xkbcommon-dl, wgpu and
    # g-desktop-portal; the fork's libx11 also ships libX11-xcb.so.1 in the same dir.
    lib.optionalString stdenv.hostPlatform.isLinux ''
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
