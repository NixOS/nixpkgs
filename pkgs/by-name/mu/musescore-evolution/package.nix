{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  wrapGAppsHook3,
  pkg-config,
  ninja,
  alsa-lib,
  alsa-plugins,
  freetype,
  libjack2,
  lame,
  libogg,
  libpulseaudio,
  libsndfile,
  libvorbis,
  portaudio,
  portmidi,
  flac,
  libopusenc,
  libopus,
  tinyxml-2,
  qt5, # Needed for musescore 3.X
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "musescore-evolution";
  version = "3.7.0-unstable-2026-01-12";

  src = fetchFromGitHub {
    owner = "Jojo-Schmitz";
    repo = "MuseScore";
    rev = "0b4543baca9b1b70d54cecb33cbf846dabc073d1";
    hash = "sha256-piOXHKlnfCO1n0kAgeszqa6JVoHgF8B2OF7agpadGKQ=";
  };

  patches = [
    ./musescore-evolution-pch-fix.patch
  ];

  # From top-level CMakeLists.txt:
  # - DOWNLOAD_SOUNDFONT defaults ON and tries to fetch from the network.
  # Download manually at Help > Manage Resources
  cmakeFlags = [
    "-DDOWNLOAD_SOUNDFONT=OFF"
  ];

  qtWrapperArgs = [
    # MuseScore JACK backend loads libjack at runtime.
    "--prefix ${lib.optionalString stdenv.hostPlatform.isDarwin "DY"}LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [ libjack2 ]
    }"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux) [
    "--set ALSA_PLUGIN_DIR ${alsa-plugins}/lib/alsa-lib"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    # There are some issues with using the wayland backend, see:
    # https://musescore.org/en/node/321936
    "--set-default QT_QPA_PLATFORM xcb"
  ];

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")

    # Recreate correct symlinks (let fixupPhase handle compression)
    if [ -e "$manDir/mscore-evo.1" ]; then
      ln -sf "mscore-evo.1" "$manDir/musescore-evo.1"
    fi
  '';

  dontWrapGApps = true;

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    cmake
    qt5.qttools
    pkg-config
    ninja
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    # Since https://github.com/musescore/MuseScore/pull/13847/commits/685ac998
    # GTK3 is needed for file dialogs. Fixes crash with No GSettings schemas error.
    wrapGAppsHook3
  ];

  buildInputs = [
    libjack2
    freetype
    lame
    libogg
    libpulseaudio
    libsndfile
    libvorbis
    portaudio
    portmidi
    flac
    libopusenc
    libopus
    tinyxml-2
    qt5.qtbase
    qt5.qtdeclarative
    qt5.qtsvg
    qt5.qtxmlpatterns
    qt5.qtquickcontrols2
    qt5.qtgraphicaleffects
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ];

  # Avoid depending on insecure QtWebEngine (and having to compile it (huge))
  # Because we don't use this, we need to patch the CMakeLists and install scripts to not try to bundle it.
  postPatch = ''
    # Disable Qt bundling logic in the source CMakeLists.
    sed -i '/QT_INSTALL_PREFIX/d' main/CMakeLists.txt
    sed -i '/QtWebEngineProcess/d' main/CMakeLists.txt
  '';

  # Patch the generated install script to drop Qt resource / QtWebEngine installs.
  preInstall = ''
    sed -i '
      /QtWebEngineProcess/d
      /resources\"/d
      /qtwebengine_locales/d
      /qtwebengine/d
      /QT_INSTALL_PREFIX/d
    ' main/cmake_install.cmake
  '';

  # On macOS, move the .app into Applications/ and symlink the binary to bin/
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications"
    mv "$out/mscore.app" "$out/Applications/mscore-evo.app"
    mkdir -p $out/bin
    ln -s $out/Applications/mscore-evo.app/Contents/MacOS/mscore $out/bin/mscore-evo
  '';

  # On Linux, let CMake + wrapQtAppsHook install/wrap "mscore", then rename it
  # and adjust the .desktop file so it doesn't clash with the main musescore package.
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    mv "$out/bin/mscore" "$out/bin/mscore-evo"

    # 2) Fix desktop entry to point to mscore-evo and avoid ID clash
    desktop="$out/share/applications/mscore.desktop"
    substitute "$desktop" "$out/share/applications/mscore-evo.desktop" \
      --replace "Exec=mscore" "Exec=mscore-evo" \
      --replace "Name=MuseScore 3.7" "Name=MuseScore 3.7 (Evolution)" \
      --replace "Icon=mscore" "Icon=mscore-evo"
    rm $desktop

    # 3) Rename app icons (apps/)
    for sizeDir in "$out"/share/icons/hicolor/*/apps/; do
      for ext in png svg xpm; do
        if [ -f "$sizeDir/mscore.$ext" ]; then
          mv "$sizeDir/mscore.$ext" "$sizeDir/mscore-evo.$ext"
        fi
      done
    done

    # 3b) Rename mimetype icons (mimetypes/) to unique names
    for icon in "$out"/share/icons/hicolor/*/mimetypes/application-x-musescore.* \
                "$out"/share/icons/hicolor/*/mimetypes/application-x-musescore+xml.*; do
      dir="''${icon%/*}"; base="''${icon##*/}"; ext="''${base##*.}"
      case "$base" in
        application-x-musescore.*) mv "$icon" "$dir/application-x-musescore-evo.$ext" ;;
        application-x-musescore+xml.*) mv "$icon" "$dir/application-x-musescore-evo+xml.$ext" ;;
      esac
    done

    # 4) Rename MIME XML and point icons to the new names
    mv "$out/share/mime/packages/musescore.xml" "$out/share/mime/packages/musescore-evo.xml"
    sed -i \
      -e 's|<icon>application-x-musescore\(\+xml\)\?</icon>|<icon>application-x-musescore-evo\1</icon>|g' \
      -e 's|<icon>musescore</icon>|<icon>mscore-evo</icon>|g' \
      "$out/share/mime/packages/musescore-evo.xml"

    # 5) Rename man pages to match mscore-evo and remove legacy symlinks
    manDir="$out/share/man/man1"

    # Remove all old musescore/mscore symlinks first (gzip may have created them)
    find "$manDir" -type l \
      \( -name 'mscore.1*' -o -name 'musescore.1*' \) \
      -exec rm -f {} +

    # Rename real files
    find "$manDir" \( -name 'mscore.1*' -o -name 'musescore.1*' \) -type f |
    while IFS= read -r man; do
      base="$(basename "$man")"
      newname=$(echo "$base" | sed -e 's/^mscore/mscore-evo/' -e 's/^musescore/mscore-evo/')
      mv "$man" "$manDir/$newname"
    done

    # 6) Rename AppStream metadata and its IDs
    meta="$out/share/metainfo/org.musescore.MuseScore.appdata.xml"
    new="$out/share/metainfo/org.musescore.MuseScoreEvolution.appdata.xml"
    mv "$meta" "$new"
    sed -i \
      -e 's|<id>org\.musescore\.MuseScore</id>|<id>org.musescore.MuseScoreEvolution</id>|' \
      -e 's|mscore\.desktop|mscore-evo.desktop|' \
      "$new"
  '';

  # Don't run bundled upstreams tests, as they require a running X window system.
  doCheck = false;

  passthru.updateScript.command = [ ./update.sh ];

  meta = {
    description = "Music notation and composition software";
    homepage = "https://github.com/Jojo-Schmitz/MuseScore";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ nemeott ];
    mainProgram = "mscore-evo";
    platforms = lib.platforms.unix;
  };
})
