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
  version = "3.7.0";

  # nix run nixpkgs#nix-prefetch-git -- https://github.com/Jojo-Schmitz/MuseScore.git 44b8c262e47864109e1a773a3bdb4e40b4759f9d
  src = fetchFromGitHub {
    owner = "Jojo-Schmitz";
    repo = "MuseScore";
    rev = "44b8c262e47864109e1a773a3bdb4e40b4759f9d";
    sha256 = "sha256-pG5CfEvgff48l7OMPEqmYW0EVSROh55bc+K5VZMzCVA=";
  };

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

    # qt5.qtwebengine # Avoid depending on insecure QtWebEngine (and having to compile it (huge))
    # Because we don't use this, we need to patch the CMakeLists and install scripts to not try to bundle it.
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ];

  # Patch out QtWebEngine and Qt resource installation/bundling.
  postPatch = ''
    # Disable Qt bundling logic in the source CMakeLists.
    if [ -f main/CMakeLists.txt ]; then
      sed -i '/QT_INSTALL_PREFIX/d' main/CMakeLists.txt
      sed -i '/QtWebEngineProcess/d' main/CMakeLists.txt
    fi
  '';

  # Patch the generated install script to drop Qt resource / QtWebEngine installs.
  preInstall = ''
    if [ -f main/cmake_install.cmake ]; then
      sed -i '
        /QtWebEngineProcess/d
        /resources\"/d
        /qtwebengine_locales/d
        /qtwebengine/d
        /QT_INSTALL_PREFIX/d
      ' main/cmake_install.cmake
    fi
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
    # 1) Rename binary
    if [ -x "$out/bin/mscore" ]; then
      mv "$out/bin/mscore" "$out/bin/mscore-evo"
    fi

    # 2) Fix desktop entry to point to mscore-evo and avoid ID clash
    desktop="$out/share/applications/mscore.desktop"
    if [ -f "$desktop" ]; then
      substituteInPlace "$desktop" \
        --replace "Exec=mscore" "Exec=mscore-evo" \
        --replace "Name=MuseScore 3.7" "Name=MuseScore 3.7 (Evolution)" \
        --replace "Icon=mscore" "Icon=mscore-evo"
      mv "$desktop" "$out/share/applications/mscore-evo.desktop"
    fi

    # 3) Rename app icons (apps/)
    if [ -d "$out/share/icons/hicolor" ]; then
      for sizeDir in "$out"/share/icons/hicolor/*/apps; do
        [ -d "$sizeDir" ] || continue
        for ext in png svg xpm; do
          if [ -f "$sizeDir/mscore.$ext" ]; then
            mv "$sizeDir/mscore.$ext" "$sizeDir/mscore-evo.$ext"
          fi
        done
      done
    fi

    # 3b) Rename mimetype icons (mimetypes/) to unique names
    for icon in "$out"/share/icons/hicolor/*/mimetypes/application-x-musescore.* \
                "$out"/share/icons/hicolor/*/mimetypes/application-x-musescore+xml.*; do
      [ -e "$icon" ] || continue
      dir="''${icon%/*}"; base="''${icon##*/}"; ext="''${base##*.}"
      case "$base" in
        application-x-musescore.*) mv "$icon" "$dir/application-x-musescore-evo.$ext" ;;
        application-x-musescore+xml.*) mv "$icon" "$dir/application-x-musescore-evo+xml.$ext" ;;
      esac
    done

    # 4) Rename MIME XML and point icons to the new names
    if [ -f "$out/share/mime/packages/musescore.xml" ]; then
      mv "$out/share/mime/packages/musescore.xml" "$out/share/mime/packages/musescore-evo.xml"
      sed -i \
        -e 's|<icon>application-x-musescore\(\+xml\)\?</icon>|<icon>application-x-musescore-evo\1</icon>|g' \
        -e 's|<icon>musescore</icon>|<icon>mscore-evo</icon>|g' \
        "$out/share/mime/packages/musescore-evo.xml"
    fi

    # 5) Rename man pages to match mscore-evo and remove legacy symlinks
    manDir="$out/share/man/man1"

    # Remove all old musescore/mscore symlinks first (gzip may have created them)
    find "$manDir" -type l \
      \( -name 'mscore.1*' -o -name 'musescore.1*' \) \
      -exec rm -f {} +

    # Rename real files
    for man in "$manDir"/mscore.1* "$manDir"/musescore.1*; do
      [ -e "$man" ] || continue
      [ -L "$man" ] && continue
      base="$(basename "$man")"
      newname=$(echo "$base" | sed -e 's/^mscore/mscore-evo/' -e 's/^musescore/mscore-evo/')
      mv "$man" "$manDir/$newname"
    done

    # Recreate correct symlinks
    for ext in 1 1.gz; do
      if [ -e "$manDir/mscore-evo.$ext" ]; then
        ln -sf "mscore-evo.$ext" "$manDir/musescore-evo.$ext"
      fi
    done

    # 6) Rename AppStream metadata and its IDs
    meta="$out/share/metainfo/org.musescore.MuseScore.appdata.xml"
    if [ -f "$meta" ]; then
      new="$out/share/metainfo/org.musescore.MuseScoreEvolution.appdata.xml"
      mv "$meta" "$new"
      sed -i \
        -e 's|<id>org\.musescore\.MuseScore</id>|<id>org.musescore.MuseScoreEvolution</id>|' \
        -e 's|mscore\.desktop|mscore-evo.desktop|' \
        "$new"
    fi
  '';

  # Don't run bundled upstreams tests, as they require a running X window system.
  doCheck = false;

  # Also don't use upstream musescore tests since this is a different version/fork.
  # passthru.tests = nixosTests.musescore;
  passthru.tests = { };

  meta = {
    description = "Music notation and composition software";
    homepage = "https://github.com/Jojo-Schmitz/MuseScore";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ nemeott ];
    mainProgram = "mscore-evo";
    platforms = lib.platforms.unix;
  };
})
