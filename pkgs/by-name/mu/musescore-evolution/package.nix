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
  __structuredAttrs = true;

  pname = "musescore-evolution";
  version = "3.7.0-unstable-2026-06-30";

  src = fetchFromGitHub {
    owner = "Jojo-Schmitz";
    repo = "MuseScore";
    rev = "8b07f250f0a657582609a870f27ea4794ec81ff2";
    hash = "sha256-XclDbyopuP4+3tfgsCThxr7QYdKmoaBSfWd+3h8A+6w=";
  };

  patches = [
    ./musescore-evolution-pch-fix.patch
  ];

  # From top-level CMakeLists.txt:
  # - DOWNLOAD_SOUNDFONT defaults ON and tries to fetch from the network.
  # Download manually at Help > Manage Resources
  cmakeFlags = [
    (lib.cmakeBool "DOWNLOAD_SOUNDFONT" false)
  ];

  qtWrapperArgs = [
    # MuseScore JACK backend loads libjack at runtime.
    "--prefix ${lib.optionalString stdenv.hostPlatform.isDarwin "DY"}LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [ libjack2 ]
    }"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "--set ALSA_PLUGIN_DIR ${alsa-plugins}/lib/alsa-lib"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    # There are some issues with using the wayland backend, see:
    # https://musescore.org/en/node/321936
    "--set-default QT_QPA_PLATFORM xcb"
  ];

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  dontWrapGApps = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt5.qttools
    qt5.wrapQtAppsHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    # Since https://github.com/musescore/MuseScore/pull/13847/commits/685ac998
    # GTK3 is needed for file dialogs. Fixes crash with No GSettings schemas error.
    wrapGAppsHook3
  ];

  buildInputs = [
    flac
    freetype
    lame
    libjack2
    libogg
    libopus
    libopusenc
    libpulseaudio
    libsndfile
    libvorbis
    portaudio
    portmidi
    qt5.qtbase
    qt5.qtdeclarative
    qt5.qtgraphicaleffects
    qt5.qtquickcontrols2
    qt5.qtsvg
    qt5.qtxmlpatterns
    tinyxml-2
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
    # 1) Rename the binaries
    mv "$out/bin/mscore" "$out/bin/mscore-evo"
    rm "$out/bin/musescore"
    ln -s "$out/bin/mscore-evo" "$out/bin/musescore-evolution"

    # 2) Fix desktop entry to point to mscore-evo and avoid ID clash
    desktop="$out/share/applications/mscore.desktop"
    substitute "$desktop" "$out/share/applications/mscore-evo.desktop" \
      --replace-fail "Exec=mscore" "Exec=mscore-evo" \
      --replace-fail "Name=MuseScore 3.7" "Name=MuseScore 3.7 (Evolution)" \
      --replace-fail "Icon=mscore" "Icon=mscore-evo" \
      --replace-fail "StartupWMClass=mscore" "StartupWMClass=MuseScore3"
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
        application-x-musescore.*) mv "$icon" "$dir/application-x-musescore-evolution.$ext" ;;
        application-x-musescore+xml.*) mv "$icon" "$dir/application-x-musescore-evolution+xml.$ext" ;;
      esac
    done

    # 4) Rename MIME XML and point icons to the new names
    mv "$out/share/mime/packages/musescore.xml" "$out/share/mime/packages/musescore-evolution.xml"
    sed -i \
      -e 's|<icon>application-x-musescore\(\+xml\)\?</icon>|<icon>application-x-musescore-evolution\1</icon>|g' \
      -e 's|<icon>musescore</icon>|<icon>mscore-evo</icon>|g' \
      "$out/share/mime/packages/musescore-evolution.xml"

    # 5) Rename man pages to match mscore-evo and remove legacy symlinks
    manDir="$out/share/man/man1"

    # Fix existing dangling aliases
    if [ -f "$manDir/mscore.1.gz" ]; then
      mv "$manDir/mscore.1.gz" "$manDir/mscore-evo.1.gz"
    fi

    # Replace old musescore.1.gz alias
    rm -f "$manDir/musescore.1.gz"
    ln -s "$manDir/mscore-evo.1.gz" "$manDir/musescore-evolution.1.gz"

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
