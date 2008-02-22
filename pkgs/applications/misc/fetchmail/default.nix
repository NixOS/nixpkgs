args: with args;
stdenv.mkDerivation {
  name="fetchmail-6.3.8";
  src = fetchurl {
    url = http://download.berlios.de/fetchmail/fetchmail-6.3.8.tar.bz2;
    sha256 = "5612f9af367f641e0efd084f44fcf1889669e711dbd8c60f6b7953e494d1b09b";
  };

  buildInputs = [ zlib openssl ];

  configureFlags = "--with-ssl=${openssl}";

  patches = [ ./security-fix.patch ];

  meta = {
    homepage = http://www.fetchmail.info;
  };
}
