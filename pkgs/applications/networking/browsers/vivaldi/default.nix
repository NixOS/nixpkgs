{ lib, stdenv, fetchurl, zlib, libX11, libXext, libSM, libICE, libxkbcommon, libxshmfence
, libXfixes, libXt, libXi, libXcursor, libXScrnSaver, libXcomposite, libXdamage, libXtst, libXrandr
, alsa-lib, dbus, cups, libexif, ffmpeg, systemd, libva, libGL
, freetype, fontconfig, libXft, libXrender, libxcb, expat
, libuuid
, libxml2
, glib, gtk3, pango, gdk-pixbuf, cairo, atk, at-spi2-atk, at-spi2-core
, qt5
, libdrm, mesa
, vulkan-loader
, nss, nspr
, patchelf, makeWrapper
, wayland, pipewire
, isSnapshot ? false
, proprietaryCodecs ? false, vivaldi-ffmpeg-codecs ? null
, enableWidevine ? false, widevine-cdm ? null
, commandLineArgs ? ""
, pulseSupport ? stdenv.hostPlatform.isLinux, libpulseaudio
, kerberosSupport ? true, libkrb5
}:

let
  branch = if isSnapshot then "snapshot" else "stable";
  vivaldiName = if isSnapshot then "vivaldi-snapshot" else "vivaldi";
in stdenv.mkDerivation rec {
  pname = "vivaldi";
  version = "6.9.3447.46";

  suffix = {
    aarch64-linux = "arm64";
    x86_64-linux = "amd64";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://downloads.vivaldi.com/${branch}/vivaldi-${branch}_${version}-1_${suffix}.deb";
    hash = {
      aarch64-linux = "sha256-r0u7u5R0lMI65zsTxIU0y5A+swJYLAj42ptJWVvFdxs=";
      x86_64-linux = "sha256-hIdgyh6c+SbeeT6uY1aN7OCPY+U2GGX6V7eHdwgyuzc=";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  unpackPhase = ''
    ar vx $src
    tar -xvf data.tar.xz
  '';

  nativeBuildInputs = [ patchelf makeWrapper ];

  dontWrapQtApps = true;

  buildInputs = [
    stdenv.cc.cc stdenv.cc.libc zlib libX11 libXt libXext libSM libICE libxcb libxkbcommon libxshmfence
    libXi libXft libXcursor libXfixes libXScrnSaver libXcomposite libXdamage libXtst libXrandr
    atk at-spi2-atk at-spi2-core alsa-lib dbus cups gtk3 gdk-pixbuf libexif ffmpeg systemd libva
    qt5.qtbase
    freetype fontconfig libXrender libuuid expat glib nss nspr libGL
    libxml2 pango cairo
    libdrm mesa vulkan-loader
    wayland pipewire
  ] ++ lib.optional proprietaryCodecs vivaldi-ffmpeg-codecs
    ++ lib.optional pulseSupport libpulseaudio
    ++ lib.optional kerberosSupport libkrb5;

  libPath = lib.makeLibraryPath buildInputs
    + lib.optionalString (stdenv.hostPlatform.is64bit)
      (":" + lib.makeSearchPathOutput "lib" "lib64" buildInputs)
    + ":$out/opt/${vivaldiName}/lib";

  buildPhase = ''
    runHook preBuild
    echo "Patching Vivaldi binaries"
    for f in chrome_crashpad_handler vivaldi-bin vivaldi-sandbox ; do
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath}" \
        opt/${vivaldiName}/$f
    done

    for f in libGLESv2.so libqt5_shim.so ; do
      patchelf --set-rpath "${libPath}" opt/${vivaldiName}/$f
    done
  '' + lib.optionalString proprietaryCodecs ''
    ln -s ${vivaldi-ffmpeg-codecs}/lib/libffmpeg.so opt/${vivaldiName}/libffmpeg.so.''${version%\.*\.*}
  '' + ''
    echo "Finished patching Vivaldi binaries"
    runHook postBuild
  '';

  dontPatchELF = true;
  dontStrip    = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    cp -r opt "$out"
    mkdir "$out/bin"
    ln -s "$out/opt/${vivaldiName}/${vivaldiName}" "$out/bin/vivaldi"
    mkdir -p "$out/share"
    cp -r usr/share/{applications,xfce4} "$out"/share
    substituteInPlace "$out"/share/applications/*.desktop \
      --replace /usr/bin/${vivaldiName} "$out"/bin/vivaldi
    substituteInPlace "$out"/share/applications/*.desktop \
      --replace vivaldi-stable vivaldi
    local d
    for d in 16 22 24 32 48 64 128 256; do
      mkdir -p "$out"/share/icons/hicolor/''${d}x''${d}/apps
      ln -s \
        "$out"/opt/${vivaldiName}/product_logo_''${d}.png \
        "$out"/share/icons/hicolor/''${d}x''${d}/apps/vivaldi.png
    done
    wrapProgram "$out/bin/vivaldi" \
      --add-flags ${lib.escapeShellArg commandLineArgs} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --set-default FONTCONFIG_FILE "${fontconfig.out}/etc/fonts/fonts.conf" \
      --set-default FONTCONFIG_PATH "${fontconfig.out}/etc/fonts" \
      --suffix XDG_DATA_DIRS : ${gtk3}/share/gsettings-schemas/${gtk3.name}/ \
      ${lib.optionalString enableWidevine "--suffix LD_LIBRARY_PATH : ${libPath}"}
  '' + lib.optionalString enableWidevine ''
    ln -sf ${widevine-cdm}/share/google/chrome/WidevineCdm $out/opt/${vivaldiName}/WidevineCdm
  '' + ''
    runHook postInstall
  '';

  passthru.updateScript = ./update-vivaldi.sh;

  meta = with lib; {
    description = "Browser for our Friends, powerful and personal";
    homepage    = "https://vivaldi.com";
    license     = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "vivaldi";
    maintainers = with maintainers; [ otwieracz badmutex ];
    platforms   = [ "x86_64-linux" "aarch64-linux" ];
  };
}
