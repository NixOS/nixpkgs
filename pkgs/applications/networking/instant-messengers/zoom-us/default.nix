{ stdenv, fetchurl, system, makeWrapper, makeDesktopItem, autoPatchelfHook
, dbus, glib, libGL, libX11, libXfixes, libuuid, libxcb, procps
, qtbase, qtdeclarative, qtlocation, qtquickcontrols2, qtscript
, qtwebchannel, qtwebengine
}:

let

  version = "2.2.128100.0627";
  srcs = {
    x86_64-linux = fetchurl {
      url = "https://zoom.us/client/${version}/zoom_x86_64.tar.xz";
      sha256 = "1x98zhs75c22x58zj4vzk8gb9yr7a9hfkbiqhjp5jrvccgz6ncin";
    };
  };

in stdenv.mkDerivation {
  name = "zoom-us-${version}";

  src = srcs.${system};

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  buildInputs = [
    dbus glib libGL libX11 libXfixes libuuid libxcb qtbase qtdeclarative
    qtlocation qtquickcontrols2 qtscript qtwebchannel qtwebengine
  ];

  installPhase =
    let
      files = stdenv.lib.concatStringsSep " " [
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

      makeWrapper $packagePath/zoom $out/bin/zoom-us \
        --prefix PATH : "${procps}/bin"

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
    maintainers = with stdenv.lib.maintainers; [ danbst ];
  };

}
