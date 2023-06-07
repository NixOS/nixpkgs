{ lib, stdenv, fetchurl, pkg-config, fltk13, portaudio, lame, libvorbis, libogg
, flac, libopus, libsamplerate, fdk_aac, dbus, openssl, curl }:

stdenv.mkDerivation rec {
  pname = "butt";
  version = "0.1.37";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-FI8xRCaGSMC6KEf5v87Q4syO3kVPWXYXgnL24+myRKo=";
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
