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
, xmonadHack ? false
}:

assert printerSupport -> cups != null;

let rev = "93d09e1a38a94c2436c53ef5ff99668e6c55ef96"; in

stdenv.mkDerivation (rec {
  name = "freerdp-1.0pre${rev}";

  src = fetchgit {
    url = git://github.com/FreeRDP/FreeRDP.git;
    inherit rev;
    sha256 = "02594c248c7d3f30d43ac11ae5ea79df1c72d98b183caf041fc05db35d211837";
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
} // (stdenv.lib.optionalAttrs xmonadHack {
   #xmonad doesn't provide the _NET_WORKAREA atom, so we need to remove the
   #call that relies on it. This just messes up sizing in non-fullscreen mode
   postUnpack = ''
    sed -i 's@xf_GetWorkArea(xfi)@///xf_GetWorkArea(xfi)@' git-export/client/X11/xf_monitor.c
  '';
}))

