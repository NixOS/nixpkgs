{stdenv, fetchurl, openssl, libX11} :

stdenv.mkDerivation (rec {
  pname = "rdesktop";
  version = "1.8.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${name}.tar.gz";
    sha256 = "0il248cdsxvwjsl4bswf27ld9r1a7d48jf6bycr86kf3i55q7k3n";
  };

  buildInputs = [openssl libX11];

  configureFlags = [
    "--with-openssl=${openssl}"
    "--disable-credssp"
    "--disable-smartcard"
  ];

  meta = {
    description = "rdesktop is an open source client for Windows Terminal Services";
  };
})
