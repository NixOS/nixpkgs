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
}:

assert printerSupport -> cups != null;
stdenv.mkDerivation rec {
  name = "freerdp-${version}";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/downloads/FreeRDP/FreeRDP/FreeRDP-${version}.tar.gz";
    sha256 = "df9f5f3275436f3e413824ca40f1e41733a95121f45e1ed41ab410701c5764cc";
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
  ] ++ stdenv.lib.optional printerSupport cups;

  configureFlags = [
    "--with-x"
  ] ++ stdenv.lib.optional printerSupport "--with-printer=cups";

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
