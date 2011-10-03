{ stdenv
, fetchgit
, openssl
, printerSupport ? true, cups
, pkgconfig
, zlib
, libX11
, libXcursor
, alsaLib
, cmake
, libxkbfile
, libXinerama
, libXext
, directfb
, cunit
}:

assert printerSupport -> cups != null;

let rev = "498b88a1da748a4a2b4dbd12c795ca87fee24bab"; in

stdenv.mkDerivation rec {
  name = "freerdp-1.0pre${rev}";

  src = fetchgit {
    url = git://github.com/FreeRDP/FreeRDP.git;
    inherit rev;
    sha256 = "91ef562e96db483ada28236e524326a75b6942becce4fd2a65ace386186eccf7";
  };

  buildInputs = [
    openssl
    pkgconfig
    zlib
    libX11
    libXcursor
    libxkbfile
    libXinerama
    libXext
    directfb
    alsaLib
    cmake
    cunit
  ] ++ stdenv.lib.optional printerSupport cups;

  doCheck = false;

  checkPhase = ''LD_LIBRARY_PATH="libfreerdp-cache:libfreerdp-chanman:libfreerdp-common:libfreerdp-core:libfreerdp-gdi:libfreerdp-kbd:libfreerdp-rail:libfreerdp-rfx:libfreerdp-utils" cunit/test_freerdp'';

  cmakeFlags = [ "-DWITH_DIRECTFB=ON" "-DWITH_CUNIT=ON" ];

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

