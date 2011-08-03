{stdenv, fetchurl, openssl, libX11} :

stdenv.mkDerivation (rec {
  pname = "rdesktop";
  version = "1.7.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${name}.tar.gz";
    sha256 = "0x2hnzvm0smnanin28n4mvzx9chpj2qnjfrxy307x21mgw6l5q1v";
  };

  buildInputs = [openssl libX11];

  configureFlags = [ "--with-openssl=${openssl}" ];

  meta = {
    description = "rdesktop is an open source client for Windows Terminal Services";
  };
})
