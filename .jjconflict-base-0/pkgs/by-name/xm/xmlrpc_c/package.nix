{
  lib,
  stdenv,
  fetchurl,
  curl,
  libxml2,
}:

stdenv.mkDerivation rec {
  pname = "xmlrpc-c";
  version = "1.59.03";

  src = fetchurl {
    url = "mirror://sourceforge/xmlrpc-c/${pname}-${version}.tgz";
    hash = "sha256-vbcdtCqwvlFZFVWIXRFoKwRMEDTUoylkAb+SHsCyM/4=";
  };

  buildInputs = [
    curl
    libxml2
  ];

  configureFlags = [
    "--enable-libxml2-backend"
  ];

  # Build and install the "xmlrpc" tool (like the Debian package)
  postInstall = ''
    (cd tools/xmlrpc && make && make install)
  '';

  enableParallelBuilding = true;

  # ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=implicit-function-declaration";

  meta = with lib; {
    description = "Lightweight RPC library based on XML and HTTP";
    homepage = "https://xmlrpc-c.sourceforge.net/";
    # <xmlrpc-c>/doc/COPYING also lists "Expat license",
    # "ABYSS Web Server License" and "Python 1.5.2 License"
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
