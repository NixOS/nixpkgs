{ stdenv
, fetchurl
, openssl
, printerSupport ? true, cups
, pkgconfig
, zlib
, libX11
, libXcursor
, alsaLib
}:

assert printerSupport -> cups != null;
stdenv.mkDerivation rec {
  name = "freerdp-0.8.2";

  src = fetchurl {
    url = "mirror://sourceforge/freerdp/${name}.tar.gz";
    sha256 = "1q9hhwyc4hk49hsmd2kghrfsawxcc7gy7vcmhdf91l8v95xp16iq";
  };

  buildInputs = [
    openssl
    pkgconfig
    zlib
    libX11
    libXcursor
    alsaLib
  ] ++ stdenv.lib.optional printerSupport cups;

  configureFlags = [
    "--with-x"
  ] ++ stdenv.lib.optional printerSupport "--with-printer=cups";
}

