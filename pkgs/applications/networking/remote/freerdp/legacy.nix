{ stdenv
, fetchurl
, cmake
, openssl
, glib, pcre
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
, pulseaudioSupport ? true
}:

assert printerSupport -> cups != null;

stdenv.mkDerivation rec {
  name = "freerdp-${version}";
  version = "1.2.0-beta1+android9";

  src = fetchurl {
    url = "https://github.com/FreeRDP/FreeRDP/archive/${version}.tar.gz";
    sha256 = "181w4lkrk5h5kh2zjlx6h2cl1mfw2aaami3laq3q32pfj06q3rxl";
  };

  buildInputs = [
    cmake
    openssl
    glib pcre
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

  preConfigure = ''
    export HOME=$TMP
  '';

  configureFlags = [
    "--with-x" "-DWITH_MANPAGES=OFF"
  ] ++ stdenv.lib.optional printerSupport "--with-printer=cups"
    ++ stdenv.lib.optional pulseaudioSupport "-DWITH_PULSEAUDIO=ON";

  meta = with stdenv.lib; {
    description = "A Remote Desktop Protocol Client";

    longDescription = ''
      FreeRDP is a client-side implementation of the Remote Desktop Protocol (RDP)
      following the Microsoft Open Specifications.
    '';

    homepage = http://www.freerdp.com/;
    license = licenses.free;
    platforms = platforms.linux;
  };
}
