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
, pulseaudioSupport ? true, pulseaudio
}:

assert printerSupport -> cups != null;
stdenv.mkDerivation rec {
  name = "freerdp-${version}";
  version = "1.0.1";

  src = fetchurl {
    url = "https://github.com/FreeRDP/FreeRDP/archive/${version}.tar.gz";
    sha256 = "1my8gamvfrn6v9gcqxsa9cgxr42shc0l826zvxj8wpcay6gd321w";
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

    license = "free-non-copyleft";

    maintainers = [ stdenv.lib.maintainers.shlevy ];
  };
}
