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
    sha256 = "a6662826fa0d8e5ecaaf42b40f1f3c54577a1d76ad58a01bd154647d5a1c01f7";
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

