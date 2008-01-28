{stdenv, fetchurl, openssl, libX11} :

stdenv.mkDerivation (rec {
  pname = "rdesktop";
  version = "1.5.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${name}.tar.gz";
    sha256 = "5ead17c3d29cb1028aeca485ee7a8c65694c1b02a1b7014c3da920b265a438aa";
  };

  buildInputs = [openssl libX11];

  configureFlags = [ "--with-openssl=${openssl}" ];

  meta = {
    description = "rdesktop is an open source client for Windows Terminal Services";
  };
})
