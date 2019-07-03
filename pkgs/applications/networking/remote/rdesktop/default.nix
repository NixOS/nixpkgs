{stdenv, fetchurl, openssl, libX11, libgssglue, pkgconfig
, enableCredssp ? (!stdenv.isDarwin)
} :

stdenv.mkDerivation (rec {
  pname = "rdesktop";
  version = "1.8.3";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${name}.tar.gz";
    sha256 = "1r7c1rjmw2xzq8fw0scyb453gy9z19774z1z8ldmzzsfndb03cl8";
  };

  nativeBuildInputs = [pkgconfig];
  buildInputs = [openssl libX11]
    ++ stdenv.lib.optional enableCredssp libgssglue;

  configureFlags = [
    "--with-ipv6"
    "--with-openssl=${openssl.dev}"
    "--disable-smartcard"
  ] ++ stdenv.lib.optional (!enableCredssp) "--disable-credssp";

  meta = {
    description = "Open source client for Windows Terminal Services";
    homepage = http://www.rdesktop.org/;
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    license = stdenv.lib.licenses.gpl2;
  };
})
