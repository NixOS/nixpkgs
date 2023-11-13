{ config, lib, stdenv
, fetchurl
, autoPatchelfHook
, makeWrapper

, alsa-lib
, curl
, gtk3
, lame
, libxml2
, ffmpeg
, vlc
, xdg-utils
, xdotool
, which

, jackSupport ? true
, jackLibrary
, pulseaudioSupport ? config.pulseaudio or true
, libpulseaudio
}:

let
  url_for_platform = version: arch: "https://www.reaper.fm/files/${lib.versions.major version}.x/reaper${builtins.replaceStrings ["."] [""] version}_linux_${arch}.tar.xz";
in
stdenv.mkDerivation rec {
  pname = "reaper";
  version = "6.82";

  src = fetchurl {
    url = url_for_platform version stdenv.hostPlatform.qemuArch;
    hash = {
      x86_64-linux = "sha256-2vtkOodMj0JGLQQn4a+XHxodHQqpnSW1ea7v6aC9sHo=";
      aarch64-linux = "sha256-FBNfXTnxqq22CnFrE2zvf6kDy/p/+SXOzqz7JS3IdG8=";
    }.${stdenv.hostPlatform.system};
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    xdg-utils # Required for desktop integration
    which
  ];

  buildInputs = [
    alsa-lib
    stdenv.cc.cc.lib # reaper and libSwell need libstdc++.so.6
    gtk3
  ];

  runtimeDependencies = [
    gtk3 # libSwell needs libgdk-3.so.0
  ]
  ++ lib.optional jackSupport jackLibrary
  ++ lib.optional pulseaudioSupport libpulseaudio;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    HOME="$out/share" XDG_DATA_HOME="$out/share" ./install-reaper.sh \
      --install $out/opt \
      --integrate-user-desktop
    rm $out/opt/REAPER/uninstall-reaper.sh

    # Dynamic loading of plugin dependencies does not adhere to rpath of
    # reaper executable that gets modified with runtimeDependencies.
    # Patching each plugin with DT_NEEDED is cumbersome and requires
    # hardcoding of API versions of each dependency.
    # Setting the rpath of the plugin shared object files does not
    # seem to have an effect for some plugins.
    # We opt for wrapping the executable with LD_LIBRARY_PATH prefix.
    # Note that libcurl and libxml2 are needed for ReaPack to run.
    wrapProgram $out/opt/REAPER/reaper \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ curl lame libxml2 ffmpeg vlc xdotool stdenv.cc.cc.lib ]}"

    mkdir $out/bin
    ln -s $out/opt/REAPER/reaper $out/bin/
    ln -s $out/opt/REAPER/reamote-server $out/bin/

    runHook postInstall
  '';

  passthru.updateScript = ./updater.sh;

  meta = with lib; {
    description = "Digital audio workstation";
    homepage = "https://www.reaper.fm/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ jfrankenau ilian orivej uniquepointer viraptor ];
  };
}
