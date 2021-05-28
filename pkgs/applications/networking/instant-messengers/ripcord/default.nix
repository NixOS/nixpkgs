{ lib, mkDerivation, fetchurl, makeFontsConf, appimageTools,
  qtbase, qtsvg, qtmultimedia, qtwebsockets, qtimageformats,
  autoPatchelfHook, desktop-file-utils, imagemagick, makeWrapper,
  twemoji-color-font, xorg, libsodium, libopus, libGL, zlib, alsaLib }:

mkDerivation rec {
  pname = "ripcord";
  version = "0.4.26";

  src = let
    appimage = fetchurl {
      url = "https://cancel.fm/dl/Ripcord-${version}-x86_64.AppImage";
      sha256 = "0i9l21gyqga27ainzqp6icn8vbc22v1knq01pglgg1lg3p504ikq";
      name = "${pname}-${version}.AppImage";
    };
  in appimageTools.extract {
    name = "${pname}-${version}";
    src = appimage;
  };

  nativeBuildInputs = [ autoPatchelfHook desktop-file-utils imagemagick ];
  buildInputs = [ libsodium libopus libGL alsaLib ] ++
                [ qtbase qtsvg qtmultimedia qtwebsockets qtimageformats ] ++
                (with xorg; [ libX11 libXScrnSaver libXcursor xkeyboardconfig ]);

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
      --run "cd $out" \
      --set FONTCONFIG_FILE "${fontsConf}" \
      --prefix LD_LIBRARY_PATH ":" "${xorg.libXcursor}/lib" \
      --prefix QT_XKB_CONFIG_ROOT ":" "${xorg.xkeyboardconfig}/share/X11/xkb" \
      --set RIPCORD_ALLOW_UPDATES 0

    runHook postInstall
  '';

  meta = with lib; {
    description = "Desktop chat client for Slack and Discord";
    homepage = "https://cancel.fm/ripcord/";

    # See: https://cancel.fm/ripcord/shareware-redistribution/
    license = licenses.unfreeRedistributable;

    maintainers = with maintainers; [ infinisil ];
    platforms = [ "x86_64-linux" ];
  };
}
