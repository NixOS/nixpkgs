{stdenv, fetchurl, openssl, libX11} :

stdenv.mkDerivation (rec {
  pname = "rdesktop";
  version = "1.8.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${name}.tar.gz";
    sha256 = "0y0s0qjfsflp4drcn75ykx6as7mn13092bcvlp2ibhilkpa27gzv";
  };

  patches = [ ./enable_windows_key.patch ];

  buildInputs = [openssl libX11];

  configureFlags = [
    "--with-openssl=${openssl}"
    "--disable-credssp"
    "--disable-smartcard"
  ];

  meta = {
    description = "Open source client for Windows Terminal Services";
    homepage = http://www.rdesktop.org/;
    platforms = stdenv.lib.platforms.linux;
    license     = stdenv.lib.licenses.gpl2;
  };
})
