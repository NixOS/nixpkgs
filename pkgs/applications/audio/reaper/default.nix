{ config, lib, stdenv
, fetchurl
, autoPatchelfHook
, makeWrapper

, alsa-lib
, gtk3
, lame
, ffmpeg
, vlc
, xdg-utils
, which

, jackSupport ? true, libjack2
, pulseaudioSupport ? config.pulseaudio or true, libpulseaudio
}:

stdenv.mkDerivation rec {
  pname = "reaper";
  version = "6.38";

  src = fetchurl {
    url = "https://www.reaper.fm/files/${lib.versions.major version}.x/reaper${builtins.replaceStrings ["."] [""] version}_linux_${stdenv.hostPlatform.qemuArch}.tar.xz";
    hash = {
      x86_64-linux = "sha256-K5EnrmzP8pyW9dR1fbMzkPzpS6aHm8JF1+m3afnH4rU=";
      aarch64-linux = "sha256-6wNWDXjQNyfU2l9Xi9JtmAuoKtHuIY5cvNMjYkwh2Sk=";
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
  ++ lib.optional jackSupport libjack2
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
    wrapProgram $out/opt/REAPER/reaper \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ lame ffmpeg vlc ]}"

    mkdir $out/bin
    ln -s $out/opt/REAPER/reaper $out/bin/
    ln -s $out/opt/REAPER/reamote-server $out/bin/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Digital audio workstation";
    homepage = "https://www.reaper.fm/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ jfrankenau ilian orivej ];
  };
}
