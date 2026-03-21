{
  lib,
  stdenv,
  fetchurl,
  makeFontsConf,
  appimageTools,
  qtbase,
  qtsvg,
  qtmultimedia,
  qtwebsockets,
  qtimageformats,
  wrapQtAppsHook,
  autoPatchelfHook,
  desktop-file-utils,
  imagemagick,
  twemoji-color-font,
  xkeyboard-config,
  libxscrnsaver,
  libxcursor,
  libx11,
  libsodium,
  libopus,
  libGL,
  alsa-lib,
}:

stdenv.mkDerivation rec {
  pname = "ripcord";
  version = "0.4.29";

  src =
    let
      appimage = fetchurl {
        url = "https://cancel.fm/dl/Ripcord-${version}-x86_64.AppImage";
        sha256 = "sha256-4yDLPEBDsPKWtLwdpmSyl3b5XCwLAr2/EVtNRrFmmJk=";
        name = "${pname}-${version}.AppImage";
      };
    in
    appimageTools.extract {
      inherit pname version;
      src = appimage;
    };

  nativeBuildInputs = [
    autoPatchelfHook
    desktop-file-utils
    imagemagick
    wrapQtAppsHook
  ];
  buildInputs = [
    libsodium
    libopus
    libGL
    alsa-lib
    qtbase
    qtsvg
    qtmultimedia
    qtwebsockets
    qtimageformats
    libx11
    libxscrnsaver
    libxcursor
    xkeyboard-config
  ];

  fontsConf = makeFontsConf {
    fontDirectories = [ twemoji-color-font ];
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r ${src}/{qt.conf,translations,twemoji.ripdb} $out

    for size in 16 32 48 64 72 96 128 192 256 512 1024; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      convert -resize "$size"x"$size" ${src}/Ripcord_Icon.png $out/share/icons/hicolor/"$size"x"$size"/apps/ripcord.png
    done

    desktop-file-install --dir $out/share/applications \
      --set-key Exec --set-value ripcord \
      --set-key Icon --set-value ripcord \
      --set-key Comment --set-value "${meta.description}" \
      ${src}/Ripcord.desktop
    mv $out/share/applications/Ripcord.desktop $out/share/applications/ripcord.desktop

    install -Dm755 ${src}/Ripcord $out/Ripcord
    patchelf --replace-needed libsodium.so.18 libsodium.so $out/Ripcord
    makeQtWrapper $out/Ripcord $out/bin/ripcord \
      --chdir "$out" \
      --set FONTCONFIG_FILE "${fontsConf}" \
      --prefix LD_LIBRARY_PATH ":" "${libxcursor}/lib" \
      --prefix QT_XKB_CONFIG_ROOT ":" "${xkeyboard-config}/share/X11/xkb" \
      --set RIPCORD_ALLOW_UPDATES 0

    runHook postInstall
  '';

  meta = {
    description = "Desktop chat client for Slack and Discord";
    homepage = "https://cancel.fm/ripcord/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    # See: https://cancel.fm/ripcord/shareware-redistribution/
    license = lib.licenses.unfreeRedistributable;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
  };
}
