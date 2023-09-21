{ lib, stdenv, fetchurl, pkg-config, fltk13, portaudio, lame, libvorbis, libogg
, flac, libopus, libsamplerate, fdk_aac, dbus, openssl, curl }:

stdenv.mkDerivation rec {
  pname = "butt";
  version = "0.1.38";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-6c4BknAh+XPaKrEfCz0oHm7lWOLV+9jiJbQx9vvtI4I=";
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
  ];

  postInstall = ''
    cp -r usr/share $out/
  '';

  meta = {
    description =
      "butt (broadcast using this tool) is an easy to use, multi OS streaming tool";
    homepage = "https://danielnoethen.de/butt/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ ehmry ];
  };
}
