{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  fltk_1_3,
  portaudio,
  lame,
  libvorbis,
  libogg,
  flac,
  libopus,
  libsamplerate,
  fdk_aac,
  dbus,
  openssl,
  curl,
  portmidi,
  autoPatchelfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "butt";
  version = "1.46.0";

  src = fetchurl {
    url = "https://danielnoethen.de/butt/release/${finalAttrs.version}/butt-${finalAttrs.version}.tar.gz";
    hash = "sha256-3RIC2H5HMn/e5Bl4XCPxxpv+FET9RgV7MxtcOuscXzs=";
  };

  postPatch = ''
    # remove advertising
    substituteInPlace src/FLTK/flgui.cpp \
      --replace-fail 'idata_radio_co_badge, 124, 61, 4,' 'nullptr, 0, 0, 0,'
    substituteInPlace src/FLTK/fl_timer_funcs.cpp \
      --replace-fail 'radio_co_logo, 124, 61, 4,' 'nullptr, 0, 0, 0,' \
      --replace-fail 'live365_logo, 124, 61, 4,' 'nullptr, 0, 0, 0,'
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    pkg-config
  ];

  buildInputs = [
    fltk_1_3
    portaudio
    lame
    libvorbis
    libogg
    flac
    libopus
    libsamplerate
    fdk_aac
    dbus
    openssl
    curl
    portmidi
  ];

  runtimeDependencies = [
    fdk_aac
  ];

  postInstall = ''
    cp -r usr/share $out/
  '';

  meta = {
    changelog = "https://danielnoethen.de/butt/Changelog.html";
    description = "Easy to use, multi OS streaming tool";
    homepage = "https://danielnoethen.de/butt/";
    license = lib.licenses.gpl2;
    mainProgram = "butt";
    platforms = lib.platforms.linux;
  };
})
