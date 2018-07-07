{ stdenv, fetchurl, system, makeWrapper, makeDesktopItem, autoPatchelfHook
# Dynamic libraries
, dbus, glib, libGL, libX11, libXfixes, libuuid, libxcb, qtbase, qtdeclarative
, qtlocation, qtquickcontrols2, qtscript, qtwebchannel, qtwebengine
# Runtime
, libjpeg_turbo, pciutils, procps, qtimageformats
, pulseaudioSupport ? true, libpulseaudio ? null
}:

assert pulseaudioSupport -> libpulseaudio != null;

let
  inherit (stdenv.lib) concatStringsSep makeBinPath optional optionalString;

  version = "2.2.128200.0702";
  srcs = {
    x86_64-linux = fetchurl {
      url = "https://zoom.us/client/${version}/zoom_x86_64.tar.xz";
      sha256 = "0n9kyj94bj35gbpwiz4kq7hc8pwfqwnfqf003g4c8gx5pda3g56w";
    };
  };

in stdenv.mkDerivation {
  name = "zoom-us-${version}";

  src = srcs.${system};

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  buildInputs = [
    dbus glib libGL libX11 libXfixes libuuid libxcb qtbase qtdeclarative
    qtlocation qtquickcontrols2 qtscript qtwebchannel qtwebengine
    libjpeg_turbo
  ];

  runtimeDependencies = optional pulseaudioSupport libpulseaudio;

  # Don't remove runtimeDependencies from RPATH via patchelf --shrink-rpath
  dontPatchELF = true;

  installPhase =
    let
      files = concatStringsSep " " [
        "*.pcm"
        "*.png"
        "ZXMPPROOT.cer"
        "ZoomLauncher"
        "config-dump.sh"
        "qtdiag"
        "timezones"
        "translations"
        "version.txt"
        "zcacert.pem"
        "zoom"
        "zoom.sh"
        "zoomlinux"
        "zopen"
      ];
    in ''
      runHook preInstall

      packagePath=$out/share/zoom-us
      mkdir -p $packagePath $out/bin

      cp -ar ${files} $packagePath

      # TODO Patch this somehow; tries to dlopen './libturbojpeg.so' from cwd
      ln -s $(readlink -e "${libjpeg_turbo.out}/lib/libturbojpeg.so") $packagePath/libturbojpeg.so

      makeWrapper $packagePath/zoom $out/bin/zoom-us \
        --prefix PATH : "${makeBinPath [ pciutils procps ]}" \
        --set QSG_INFO 1 \
        --set QT_QPA_PLATFORM_PLUGIN_PATH ${qtbase.bin}/lib/qt-${qtbase.qtCompatVersion}/plugins/platforms \
        --set QT_PLUGIN_PATH ${qtbase.bin}/${qtbase.qtPluginPrefix}:${qtimageformats}/${qtbase.qtPluginPrefix} \
        --run "cd $packagePath"

      runHook postInstall
    '';

  postInstall = (makeDesktopItem {
    name = "zoom-us";
    exec = "$out/bin/zoom-us %U";
    icon = "$out/share/zoom-us/application-x-zoom.png";
    desktopName = "Zoom";
    genericName = "Video Conference";
    categories = "Network;Application;";
    mimeType = "x-scheme-handler/zoommtg;";
  }).buildCommand;

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = https://zoom.us/;
    description = "zoom.us video conferencing application";
    license = stdenv.lib.licenses.unfree;
    platforms = builtins.attrNames srcs;
    maintainers = with stdenv.lib.maintainers; [ danbst tadfisher ];
  };

}
