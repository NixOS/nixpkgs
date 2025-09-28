{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  coreutils,
  bash,
  gawk,
  libpulseaudio,
  alsa-lib,
  libnotify,
}:

stdenv.mkDerivation rec {
  pname = "i3-volume";
  version = "3.9.0";

  src = fetchFromGitHub {
    owner = "hastinbe";
    repo = "i3-volume";
    rev = "v${version}";
    hash = "sha256-vmyfEXJ/5TRWIJQCblYcy8owI03F+ARNAEd0ni5ublM=";
  };

  buildInputs = [
    libpulseaudio
    alsa-lib
    libnotify
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 volume $out/bin/i3-volume
    mkdir -p $out/share/doc/i3-volume/
    cp -a i3volume-alsa.conf $out/share/doc/i3-volume/i3volume-alsa.conf
    cp -a i3volume-pulseaudio.conf $out/share/doc/i3-volume/i3volume-pulseaudio.conf

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  # Example usage for `services.pipewire.enabled = true;` (will use `amixer` program) - `i3-volume -a -n -c 0 up 100`
  meta = {
    description = "Volume control with on-screen display notifications";
    longDescription = ''
      Use keyboard volume keys to mute, increase, or decrease the volume. Volume indicators in status lines will be updated and, when notifications are enabled, a popup will display the volume level.

      Works with any window manager, such as [i3wm](https://i3wm.org/), [bspwm](https://github.com/baskerville/bspwm), and [KDE](https://kde.org/), as a standalone script, or with statusbars such as [polybar](https://github.com/polybar/polybar), [i3blocks](https://github.com/vivien/i3blocks), [i3status](https://github.com/i3/i3status), and more.
    '';
    homepage = "https://github.com/hastinbe/i3-volume";
    mainProgram = "i3-volume";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
