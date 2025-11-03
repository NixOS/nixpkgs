{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  boost,
  fcgi,
  openssl,
  opensaml-cpp,
  log4shib,
  pkg-config,
  xercesc,
  xml-security-c,
  xml-tooling-c,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shibboleth-sp";
  version = "3.5.1";

  src = fetchurl {
    url = "https://shibboleth.net/downloads/service-provider/${finalAttrs.version}/shibboleth-sp-${finalAttrs.version}.tar.gz";
    hash = "sha256-KOm+X4jlAPCfH2CkRj7PUh56skByShJzhze4h8lJPKs=";
  };

  patches = [ ./fix-boost-detection.patch ]; # Fix Boost include path detection

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    boost
    fcgi
    openssl
    opensaml-cpp
    log4shib
    xercesc
    xml-security-c
    xml-tooling-c
  ];

  preConfigure = ''
    export boost="${boost}"
  '';

  configureFlags = [
    "--without-apxs"
    "--with-xmltooling=${xml-tooling-c}"
    "--with-saml=${opensaml-cpp}"
    "--with-fastcgi"
    "CXXFLAGS=-std=c++14"
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://shibboleth.atlassian.net/wiki/spaces/SP3/overview";
    description = "Enables SSO and Federation web applications written with any programming language or framework";
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
