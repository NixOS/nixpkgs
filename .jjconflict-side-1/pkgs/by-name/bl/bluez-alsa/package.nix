{ lib
, stdenv
, aacSupport ? true
, alsa-lib
, autoreconfHook
, bluez
, dbus
, fdk_aac
, fetchFromGitHub
, gitUpdater
, glib
, libbsd
, ncurses
, pkg-config
, readline
, sbc
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bluez-alsa";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "Arkq";
    repo = "bluez-alsa";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oGaYiSkOhqfjUl+mHTs3gqFcxli3cgkRtT6tbjy3ht0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    bluez
    glib
    sbc
    dbus
    readline
    libbsd
    ncurses
  ] ++ lib.optionals aacSupport [
    fdk_aac
  ];

  configureFlags = [
    (lib.enableFeature aacSupport "aac")
    (lib.enableFeature true "hcitop")
    (lib.enableFeature true "rfcomm")
    (lib.withFeatureAs true "alsaplugindir" "${placeholder "out"}/lib/alsa-lib")
    (lib.withFeatureAs true "dbusconfdir" "${placeholder "out"}/share/dbus-1/system.d")
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/Arkq/bluez-alsa";
    description = "Bluez 5 Bluetooth Audio ALSA Backend";
    longDescription = ''
      Bluez-ALSA (BlueALSA) is an ALSA backend for Bluez 5 audio interface.
      Bluez-ALSA registers all Bluetooth devices with audio profiles in Bluez
      under a virtual ALSA PCM device called `bluealsa` that supports both
      playback and capture.

      Some backstory: Bluez 5 removed built-in support for ALSA in favor of a
      generic interface for 3rd party appliations. Thereafter, PulseAudio
      implemented a backend for that interface and became the only way to get
      Bluetooth audio with Bluez 5. Users prefering ALSA stayed on Bluez 4.
      However, Bluez 4 eventually became deprecated.

      This package is a rebirth of a direct interface between ALSA and Bluez 5,
      that, unlike PulseAudio, provides KISS near-metal-like experience. It is
      not possible to run BluezALSA and PulseAudio Bluetooth at the same time
      due to limitations in Bluez, but it is possible to run PulseAudio over
      BluezALSA if you disable `bluetooth-discover` and `bluez5-discover`
      modules in PA and configure it to play/capture sound over `bluealsa` PCM.
    '';
    license = with lib.licenses; [ mit ];
    mainProgram = "bluealsa";
    maintainers = with lib.maintainers; [ oxij ];
    platforms = lib.platforms.linux;
  };
})
# TODO: aptxSupport
