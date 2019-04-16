{ stdenv, fetchurl, makeWrapper, makeDesktopItem, autoPatchelfHook, env
# Dynamic libraries
, dbus, glib, libGL, libX11, libXfixes, libuuid, libxcb, qtbase, qtdeclarative
, qtimageformats, qtlocation, qtquickcontrols, qtquickcontrols2, qtscript, qtsvg
, qttools, qtwayland, qtwebchannel, qtwebengine
# Runtime
, coreutils, libjpeg_turbo, pciutils, procps, utillinux
, pulseaudioSupport ? true, libpulseaudio ? null
}:

assert pulseaudioSupport -> libpulseaudio != null;

let
  inherit (stdenv.lib) concatStringsSep makeBinPath optional;

  version = "2.8.183302.0415";
  srcs = {
    x86_64-linux = fetchurl {
      url = "https://zoom.us/client/${version}/zoom_x86_64.tar.xz";
      sha256 = "07afq614fy09mjymmv3cf8vwa8ps78s2s4909g1a2rwvgkj8bw2x";
    };
  };

  qtDeps = [
    qtbase qtdeclarative qtlocation qtquickcontrols qtquickcontrols2 qtscript
    qtwebchannel qtwebengine qtimageformats qtsvg qttools qtwayland
  ];

  qtEnv = env "zoom-us-qt-${qtbase.version}" qtDeps;

in stdenv.mkDerivation {
  name = "zoom-us-${version}";

  src = srcs.${stdenv.hostPlatform.system};

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  buildInputs = [
    dbus glib libGL libX11 libXfixes libuuid libxcb qtEnv libjpeg_turbo
  ] ++ qtDeps;

  runtimeDependencies = optional pulseaudioSupport libpulseaudio;

  installPhase =
    let
      files = concatStringsSep " " [
        "*.pcm"
        "*.png"
        "ZoomLauncher"
        "config-dump.sh"
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

      ln -s ${qtEnv}/bin/qt.conf $packagePath

      makeWrapper $packagePath/zoom $out/bin/zoom-us \
        --prefix PATH : "${makeBinPath [ coreutils glib.dev pciutils procps qttools.dev utillinux ]}" \
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
