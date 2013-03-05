{ stdenv
, fetchgit
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
#, directfb
#, cunit
, libXv
, pulseaudioSupport ? true, pulseaudio
}:

assert printerSupport -> cups != null;

let rev = "ec6effcb1e7759551cf31f5b18d768afc67db97d"; in

stdenv.mkDerivation rec {
  name = "freerdp-1.1pre${rev}";

  src = fetchgit {
    url = git://github.com/FreeRDP/FreeRDP.git;
    inherit rev;
    sha256 = "4e5af9a6769c4b34c6b75dffe83a385d1d86068c523ea9f62fabc651a2958455";
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
#    directfb
#    cunit
    alsaLib
    ffmpeg
    libxkbfile
#    xmlto docbook_xml_dtd_412 docbook_xml_xslt
    libXinerama
    libXv
  ] ++ stdenv.lib.optional printerSupport cups;

  doCheck = false;

  checkPhase = ''LD_LIBRARY_PATH="libfreerdp-cache:libfreerdp-chanman:libfreerdp-common:libfreerdp-core:libfreerdp-gdi:libfreerdp-kbd:libfreerdp-rail:libfreerdp-rfx:libfreerdp-utils" cunit/test_freerdp'';

  cmakeFlags = [ "-DWITH_DIRECTFB=OFF" "-DWITH_CUNIT=OFF" "-DWITH_MANPAGES=OFF" 
  ] ++ stdenv.lib.optional pulseaudioSupport "-DWITH_PULSEAUDIO=ON";

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

