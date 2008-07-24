{stdenv, fetchurl, openssl, libX11} :

stdenv.mkDerivation (rec {
  pname = "rdesktop";
  version = "1.6.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${name}.tar.gz";
    sha256 = "0y890s5rv47ipcijcrmcy9988br22ipr4c1ppb88pjhlism6w0im";
  };

  buildInputs = [openssl libX11];

  configureFlags = [ "--with-openssl=${openssl}" ];

  meta = {
    description = "rdesktop is an open source client for Windows Terminal Services";
  };
})
