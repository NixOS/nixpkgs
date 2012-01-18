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
    sha256 = "1h7b2ykgsp1b04p67syb3p2xgpsb45i6zl1jvm09h0dr5an85awd";
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
