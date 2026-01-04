{
  alsa-lib,
  autoPatchelfHook,
  buildFHSEnv,
  elfutils,
  extraEnv ? { },
  fetchurl,
  ffmpeg_6-headless,
  lib,
  libdrm,
  libgbm,
  libpulseaudio,
  libva,
  libxkbcommon,
  libxml2_13,
  makeShellWrapper,
  minizip,
  nss,
  squashfsTools,
  stdenv,
  writeShellScript,
  xkeyboard_config,
  xorg,
}:
let
  pname = "plex-htpc";
  version = "1.71.1";
  rev = "73";
  meta = {
    homepage = "https://plex.tv/";
    description = "Plex HTPC client for the big screen";
    longDescription = ''
      Plex HTPC for Linux is your client for playing on your Linux computer
      connected to the big screen. It features a 10-foot interface with a
      powerful playback engine.
    '';
    maintainers = with lib.maintainers; [ detroyejr ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "plex-htpc";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
  plex-htpc = stdenv.mkDerivation {
    inherit pname version meta;

    src = fetchurl {
      url = "https://api.snapcraft.io/api/v1/snaps/download/81OP06hEXlwmMrpMAhe5hyLy5bQ9q6Kz_${rev}.snap";
      hash = "sha512-n9pXRx8s6AwhIJm7PmUIOB8pXqzyNFzdmwJMonQ4WzWvA5tPI27x0slQ6WUxRBQJoLScGckyGAFxIGWRylNr3g==";
    };

    nativeBuildInputs = [
      autoPatchelfHook
      makeShellWrapper
      squashfsTools
    ];

    buildInputs = [
      elfutils
      ffmpeg_6-headless
      libgbm
      libpulseaudio
      libva
      libxkbcommon
      libxml2_13
      minizip
      nss
      stdenv.cc.cc
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXinerama
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
      xorg.libxshmfence
      xorg.xcbutilimage
      xorg.xcbutilkeysyms
      xorg.xcbutilrenderutil
      xorg.xcbutilwm
      xorg.xrandr
    ];

    strictDeps = true;

    unpackPhase = ''
      runHook preUnpack
      unsquashfs "$src"
      cd squashfs-root
      runHook postUnpack
    '';

    dontStrip = true;
    dontWrapQtApps = true;

    installPhase = ''
      runHook preInstall

      cp -r . $out
      rm -r $out/etc
      rm -r $out/usr

      # flatpak removes these during installation.
      rm -r $out/lib/dri
      rm $out/lib/libpciaccess.so*
      rm $out/lib/libswresample.so*
      rm $out/lib/libva-*.so*
      rm $out/lib/libva.so*
      rm $out/lib/libEGL.so*
      rm $out/lib/libdrm.so*
      rm $out/lib/libdrm*

      # Keep some dependencies from the snap.
      cp usr/lib/x86_64-linux-gnu/liblcms2.so.2 $out/lib/liblcms2.so.2
      cp usr/lib/x86_64-linux-gnu/libjbig.so.0 $out/lib/libjbig.so.0
      cp usr/lib/x86_64-linux-gnu/libjpeg.so.8 $out/lib/libjpeg.so.8
      cp usr/lib/x86_64-linux-gnu/libpci.so.3 $out/lib/libpci.so.3
      cp usr/lib/x86_64-linux-gnu/libsnappy.so.1 $out/lib/libsnappy.so.1
      cp usr/lib/x86_64-linux-gnu/libtiff.so.5 $out/lib/libtiff.so.5
      cp usr/lib/x86_64-linux-gnu/libwebp.so.6 $out/lib/libwebp.so.6
      cp usr/lib/x86_64-linux-gnu/libxkbfile.so.1 $out/lib/libxkbfile.so.1
      cp usr/lib/x86_64-linux-gnu/libxslt.so.1 $out/lib/libxslt.so.1

      runHook postInstall
    '';
  };
in
buildFHSEnv {
  inherit pname version meta;
  targetPkgs = pkgs: [
    alsa-lib
    libdrm
    xkeyboard_config
  ];

  extraInstallCommands = ''
    mkdir -p $out/share/applications $out/share/icons/hicolor/scalable/apps
    install -m 444 -D ${plex-htpc}/meta/gui/plex-htpc.desktop $out/share/applications/plex-htpc.desktop
    substituteInPlace $out/share/applications/plex-htpc.desktop \
      --replace-fail \
      'Icon=''${SNAP}/meta/gui/icon.png' \
      'Icon=${plex-htpc}/meta/gui/icon.png'
  '';

  runScript = writeShellScript "plex-htpc.sh" ''
    # Widevine won't download unless this directory exists.
    mkdir -p $HOME/.cache/plex/

    # Copy the sqlite plugin database on first run.
    PLEX_DB="$HOME/.local/share/plex/Plex Media Server/Plug-in Support/Databases"
    if [[ ! -d "$PLEX_DB" ]]; then
      mkdir -p "$PLEX_DB"
      cp "${plex-htpc}/resources/com.plexapp.plugins.library.db" "$PLEX_DB"
    fi

    # db files should have write access.
    chmod --recursive 750 "$PLEX_DB"

    # These environment variables sometimes silently cause plex to crash.
    unset QT_QPA_PLATFORM QT_STYLE_OVERRIDE

    set -o allexport
    ${lib.toShellVars extraEnv}
    set +o allexport
    exec ${plex-htpc}/Plex.sh
  '';
  passthru.updateScript = ./update.sh;
}
