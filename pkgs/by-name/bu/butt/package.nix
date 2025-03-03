{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  fltk13,
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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "butt";
  version = "1.44.0";

  src = fetchurl {
    url = "https://danielnoethen.de/butt/release/${finalAttrs.version}/butt-${finalAttrs.version}.tar.gz";
    hash = "sha256-2RC0ChDbyhzjd+4jnBRuR0botIVQugpA1rUZm1yH4Kc=";
  };

  postPatch = ''
    # remove advertising
    substituteInPlace src/FLTK/flgui.cpp \
      --replace-fail 'idata_radio_co_badge, 124, 61, 4,' 'nullptr, 0, 0, 0,'
    substituteInPlace src/FLTK/fl_timer_funcs.cpp \
      --replace-fail 'radio_co_logo, 124, 61, 4,' 'nullptr, 0, 0, 0,' \
      --replace-fail 'live365_logo, 124, 61, 4,' 'nullptr, 0, 0, 0,'
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    fltk13
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

  postInstall = ''
    cp -r usr/share $out/
  '';

  meta = {
    changelog = "https://danielnoethen.de/butt/Changelog.html";
    description = "butt (broadcast using this tool) is an easy to use, multi OS streaming tool";
    homepage = "https://danielnoethen.de/butt/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ ehmry ];
    mainProgram = "butt";
    platforms = lib.platforms.linux;
  };
})
