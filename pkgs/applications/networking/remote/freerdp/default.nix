{ stdenv
, fetchurl
, cmake
, openssl
, printerSupport ? true, cups
, pkgconfig
, zlib
, libX11
, libXcursor
, libXdamage
, libXext
, alsaLib
, ffmpeg
, libxkbfile
#, xmlto, docbook_xml_dtd_412, docbook_xml_xslt
, libXinerama
, libXv
, pulseaudioSupport ? true, libpulseaudio
}:

assert printerSupport -> cups != null;
stdenv.mkDerivation rec {
  name = "freerdp-${version}";
  version = "1.0.2";

  src = fetchurl {
    url = "https://github.com/FreeRDP/FreeRDP/archive/${version}.tar.gz";
    sha256 = "1w9dk7dsbppspnnms2xwwmbg7jm61i7aw5nkwzbpdyxngbgkgwf0";
  };

  buildInputs = [
    cmake
    openssl
    pkgconfig
    zlib
    libX11
    libXcursor
    libXdamage
    libXext
    alsaLib
    ffmpeg
    libxkbfile
#    xmlto docbook_xml_dtd_412 docbook_xml_xslt
    libXinerama
    libXv
  ] ++ stdenv.lib.optional printerSupport cups;

  configureFlags = [
    "--with-x" "-DWITH_MANPAGES=OFF"
  ] ++ stdenv.lib.optional printerSupport "--with-printer=cups"
    ++ stdenv.lib.optional pulseaudioSupport "-DWITH_PULSEAUDIO=ON";

  meta = {
    description = "A Remote Desktop Protocol Client";

    longDescription = ''
      FreeRDP is a client-side implementation of the Remote Desktop Protocol (RDP)
      following the Microsoft Open Specifications.
    '';

    homepage = http://www.freerdp.com/;

    license = stdenv.lib.licenses.free;
    platforms = stdenv.lib.platforms.linux;
  };
}
