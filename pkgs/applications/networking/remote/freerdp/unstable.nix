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

let rev = "42fb9f84e82268073a3838e6082783ba956ecc99"; in

stdenv.mkDerivation rec {
  name = "freerdp-1.0pre${rev}";

  src = fetchgit {
    url = git://github.com/FreeRDP/FreeRDP.git;
    inherit rev;
    sha256 = "5e77163e2a728802fc426860b3f5ff88cb2f2f3b0bbf0912e9e44c3d8fa060e5";
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

  postUnpack = ''
    sed -i 's@xf_GetWorkArea(xfi)@///xf_GetWorkArea(xfi)@' git-export/client/X11/xf_monitor.c
  '';

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

