{
  lib,
  stdenv,
  fetchFromCodeberg,
  autoreconfHook,
  pkg-config,
  boost,
  openssl,
  log4shib,
  xercesc,
  xml-security-c,
  xml-tooling-c,
  zlib,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opensaml-cpp";
  version = "3.0.1";

  src = fetchFromCodeberg {
    owner = "Shibboleth";
    repo = "cpp-opensaml";
    tag = finalAttrs.version;
    hash = "sha256-iBfKM40SzCiDGHacnxc7zZdvOYbCy9NEWjhPzCvWQ1c=";
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

  configureFlags = [
    "--with-xmltooling=${xml-tooling-c}"
    "--with-boost=${boost.dev}"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString (!stdenv.hostPlatform.isDarwin) "-std=c++14";

  enableParallelBuilding = true;

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://shibboleth.net/products/opensaml-cpp.html";
    description = "Low-level library written in C++ that provides support for producing and consuming SAML messages";
    mainProgram = "samlsign";
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ drawbu ];
  };
})
