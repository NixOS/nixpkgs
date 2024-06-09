{ lib, stdenv, fetchurl, pkg-config, fltk13, portaudio, lame, libvorbis, libogg
, flac, libopus, libsamplerate, fdk_aac, dbus, openssl, curl, portmidi }:

stdenv.mkDerivation (finalAttrs: {
  pname = "butt";
  version = "1.42.0";

  src = fetchurl {
    url = "https://danielnoethen.de/butt/release/${finalAttrs.version}/butt-${finalAttrs.version}.tar.gz";
    hash = "sha256-/Y96Pq/3D37n/2JZdvcEQ1BBEtHlJ030QLesfNyBg2g=";
  };

  postPatch = ''
    # remove advertising
    substituteInPlace src/FLTK/flgui.cpp \
      --replace 'idata_radio_co_badge, 124, 61, 4,' 'nullptr, 0, 0, 0,'
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
    description =
      "butt (broadcast using this tool) is an easy to use, multi OS streaming tool";
    homepage = "https://danielnoethen.de/butt/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ ehmry ];
    mainProgram = "butt";
    platforms = lib.platforms.linux;
  };
})
