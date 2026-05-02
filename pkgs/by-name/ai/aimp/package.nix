{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  makeWrapper,
  wrapGAppsHook3,
  gtk3,
  glib,
  cairo,
  pango,
  gdk-pixbuf,
  atk,
  harfbuzz,
  zlib,
  fontconfig,
  freetype,
  sqlite,
  libx11,
  libogg,
  # Runtime-only dependencies (dlopen'd by AIMP from its install directory)
  alsa-lib,
  libpulseaudio,
  curl,
  libvorbis,
  soxr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aimp";
  version = "6.00.3051";

  src = fetchurl {
    url = "https://aimp.ru/files/desktop/builds/aimp_6.00-3051b_amd64.deb";
    hash = "sha256-vqI/0oDS+Qk3ep01bXbAq+/DD65INzK7xQA8nYWOZ7Y=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    glib
    cairo
    pango
    gdk-pixbuf
    atk
    harfbuzz
    zlib
    fontconfig
    freetype
    sqlite
    libx11
    libogg
  ];

  # Prevent wrapGAppsHook from wrapping automatically; we do it manually
  dontWrapGApps = true;

  unpackPhase = ''
    runHook preUnpack
    dpkg -x $src .
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,opt/aimp,share}

    # Install main application files
    cp -r opt/aimp/* $out/opt/aimp/

    # Install bundled shared libraries alongside the binary
    # (AIMP searches for dlopen'd libraries relative to its executable)
    cp usr/lib/x86_64-linux-gnu/* $out/opt/aimp/

    # Symlink runtime-only dependencies into the AIMP directory
    ln -s ${curl.out}/lib/libcurl.so.4 $out/opt/aimp/
    ln -s ${alsa-lib}/lib/libasound.so.2 $out/opt/aimp/libasound.so
    ln -s ${libogg}/lib/libogg.so.0 $out/opt/aimp/libogg.so
    ln -s ${libvorbis}/lib/libvorbis.so.0 $out/opt/aimp/libvorbis.so
    ln -s ${libvorbis}/lib/libvorbisenc.so.2 $out/opt/aimp/libvorbisenc.so
    ln -s ${soxr}/lib/libsoxr.so.0 $out/opt/aimp/libsoxr.so

    # Install icons, desktop files, and appdata
    cp -r usr/share/icons $out/share/
    cp -r usr/share/applications $out/share/
    cp -r usr/share/metainfo $out/share/

    # Fix desktop file paths
    substituteInPlace $out/share/applications/aimp.desktop \
      --replace-fail "Exec=aimp" "Exec=$out/bin/aimp" \
      --replace-fail "Exec=/opt/aimp/AIMPac" "Exec=$out/bin/aimpac" \
      --replace-fail "Exec=/opt/aimp/AIMPate" "Exec=$out/bin/aimpate"

    substituteInPlace $out/share/applications/aimp.utils.converter.desktop \
      --replace-fail "Exec=/opt/aimp/AIMPac" "Exec=$out/bin/aimpac"

    substituteInPlace $out/share/applications/aimp.utils.tageditor.desktop \
      --replace-fail "Exec=/opt/aimp/AIMPate" "Exec=$out/bin/aimpate"

    # Remove debug symbol files
    find $out -name "*.dbgsym" -delete

    # Create wrappers with GTK environment
    for bin in AIMP AIMPac AIMPate; do
      lower=$(echo "$bin" | tr '[:upper:]' '[:lower:]')
      makeWrapper $out/opt/aimp/$bin $out/bin/$lower \
        "''${gappsWrapperArgs[@]}" \
        --prefix LD_LIBRARY_PATH : "$out/opt/aimp" \
        --prefix LD_LIBRARY_PATH : "${
          lib.makeLibraryPath [
            libpulseaudio
          ]
        }"
    done

    runHook postInstall
  '';

  meta = {
    description = "Powerful free audio player, converter and tag editor";
    homepage = "https://www.aimp.ru";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ sophronesis ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "aimp";
  };
})
