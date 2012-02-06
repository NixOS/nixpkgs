{stdenv, fetchurl, openssl, libX11} :

stdenv.mkDerivation (rec {
  pname = "rdesktop";
  version = "1.7.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${name}.tar.gz";
    sha256 = "0yc4xz95w40m8ailpjgqp9h7bkc758vp0dlq4nj1pvr3xfnl7sni";
  };

  buildInputs = [openssl libX11];

  configureFlags = [ "--with-openssl=${openssl}" ];

  meta = {
    description = "rdesktop is an open source client for Windows Terminal Services";
  };
})
