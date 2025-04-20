{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  pkg-config,
  boost,
  openssl,
  log4shib,
  xercesc,
  xml-security-c,
  xml-tooling-c,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "opensaml-cpp";
  version = "3.0.1";

  src = fetchgit {
    url = "https://git.shibboleth.net/git/cpp-opensaml.git";
    rev = version;
    sha256 = "0ms3sqmwqkrqb92d7jy2hqwnz5yd7cbrz73n321jik0jilrwl5w8";
  };

  buildInputs = [
    boost
    openssl
    log4shib
    xercesc
    xml-security-c
    xml-tooling-c
    zlib
  ];
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  configureFlags = [ "--with-xmltooling=${xml-tooling-c}" ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString (!stdenv.hostPlatform.isDarwin) "-std=c++14";

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://shibboleth.net/products/opensaml-cpp.html";
    description = "Low-level library written in C++ that provides support for producing and consuming SAML messages";
    mainProgram = "samlsign";
    platforms = platforms.unix;
    license = licenses.asl20;
    maintainers = [ ];
  };
}
