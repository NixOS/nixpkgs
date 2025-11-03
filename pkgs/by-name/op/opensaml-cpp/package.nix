{
  lib,
  stdenv,
  fetchurl,
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

stdenv.mkDerivation (finalAttrs: {
  pname = "opensaml-cpp";
  version = "3.3.1";

  src = fetchurl {
    url = "https://shibboleth.net/downloads/c++-opensaml/${finalAttrs.version}/opensaml-${finalAttrs.version}.tar.gz";
    hash = "sha256-nQcW1S1PFOU7GxneSZOH4iNe+BFej+yhuhKk4v1Q0EY=";
  };

  patches = [ ./fix-boost-detection.patch ]; # Fix Boost include path detection

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

  preConfigure = ''
    export boost="${boost}"
  '';

  configureFlags = [ "--with-xmltooling=${xml-tooling-c}" ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString (!stdenv.hostPlatform.isDarwin) "-std=c++14";

  enableParallelBuilding = true;

  meta = {
    homepage = "https://shibboleth.atlassian.net/wiki/spaces/SP3/pages/2067398807/OpenSAML-C";
    description = "Low-level library written in C++ that provides support for producing and consuming SAML messages";
    mainProgram = "samlsign";
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ iedame ];
  };
})
